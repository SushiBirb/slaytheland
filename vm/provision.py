#!/usr/bin/env python3
"""
slaytheland VM Provisioner
Connects to the freshly booted Arch Linux VM, installs SSH keys, mounts
the shared folder, and installs Hyprland + GUI packages.
"""

import sys
import os
import time
import socket
import select
import pty
import subprocess

DIR = os.path.dirname(os.path.abspath(__file__))
KEY_PUB = os.path.join(DIR, "id_ed25519.pub")
KEY_PRIV = os.path.join(DIR, "id_ed25519")

def wait_for_ssh(host="localhost", port=2222, timeout=120):
    print(f">> Waiting for SSH on {host}:{port}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            with socket.create_connection((host, port), timeout=2) as s:
                banner = s.recv(1024)
                if b"SSH" in banner:
                    print(f">> SSH is live! ({banner.decode().strip()})")
                    return True
        except Exception:
            time.sleep(2)
    print("!! Timed out waiting for SSH")
    return False

def ssh_run_initial(command):
    """Run an initial command using password 'arch' via pseudo-terminal."""
    cmd = [
        "ssh", "-p", "2222",
        "-o", "StrictHostKeyChecking=no",
        "-o", "UserKnownHostsFile=/dev/null",
        "arch@localhost",
        command
    ]
    pid, fd = pty.fork()
    if pid == 0:
        os.execvp("ssh", cmd)
    else:
        out = bytearray()
        sent_pw = False
        while True:
            r, _, _ = select.select([fd], [], [], 30)
            if not r:
                break
            try:
                chunk = os.read(fd, 1024)
                if not chunk:
                    break
                out.extend(chunk)
                if b"password:" in chunk.lower() and not sent_pw:
                    os.write(fd, b"arch\n")
                    sent_pw = True
            except OSError:
                break
        _, status = os.waitpid(pid, 0)
        return status == 0

def ssh_key_exec(command, capture=True):
    """Run a command using the installed ed25519 key."""
    cmd = [
        "ssh", "-p", "2222",
        "-i", KEY_PRIV,
        "-o", "StrictHostKeyChecking=no",
        "-o", "UserKnownHostsFile=/dev/null",
        "-o", "LogLevel=ERROR",
        "arch@localhost",
        command
    ]
    if capture:
        res = subprocess.run(cmd, capture_output=True, text=True)
        return res.returncode, res.stdout, res.stderr
    else:
        res = subprocess.run(cmd)
        return res.returncode, "", ""

def main():
    if not wait_for_ssh():
        sys.exit(1)

    time.sleep(1)
    print(">> Step 1: Injecting SSH public key into VM...")
    pubkey = open(KEY_PUB).read().strip()
    inject_cmd = (
        f"mkdir -p ~/.ssh && chmod 700 ~/.ssh && "
        f"grep -qxF '{pubkey}' ~/.ssh/authorized_keys 2>/dev/null || echo '{pubkey}' >> ~/.ssh/authorized_keys && "
        f"chmod 600 ~/.ssh/authorized_keys"
    )
    if not ssh_run_initial(inject_cmd):
        print("   Retrying initial key injection...")
        time.sleep(2)
        ssh_run_initial(inject_cmd)

    print(">> Step 2: Testing key-based SSH authentication...")
    ret, out, err = ssh_key_exec("echo 'Key auth verified'")
    if ret != 0:
        print(f"!! SSH key auth failed: {err}")
        sys.exit(1)
    print(f"   {out.strip()}")

    print(">> Step 3: Initializing pacman keyring...")
    ssh_key_exec("sudo pacman-key --init && sudo pacman-key --populate archlinux")

    print(">> Step 4: Setting up 9p shared folder (/home/arch/slaytheland)...")
    setup_share = (
        "sudo mkdir -p /home/arch/slaytheland && "
        "sudo chown arch:arch /home/arch/slaytheland && "
        "grep -q 'slaytheland' /etc/fstab || echo 'slaytheland /home/arch/slaytheland 9p trans=virtio,version=9p2000.L,rw,_netdev 0 0' | sudo tee -a /etc/fstab && "
        "sudo mount -a"
    )
    ret, out, err = ssh_key_exec(setup_share)
    if ret != 0:
        print(f"   Share mount warning: {err}")
    else:
        print("   Shared directory mounted successfully!")

    print(">> Step 5: Installing Hyprland, Waybar, Kitty, Mesa, and desktop stack...")
    packages = [
        "hyprland",
        "kitty",
        "mesa",
        "waybar",
        "wofi",
        "xdg-desktop-portal-hyprland",
        "polkit-kde-agent",
        "pipewire",
        "pipewire-pulse",
        "wireplumber",
        "noto-fonts",
        "brightnessctl"
    ]
    pkg_str = " ".join(packages)
    install_cmd = f"sudo pacman -Sy --noconfirm --needed {pkg_str}"
    print(f"   Running pacman install (this takes ~30s)...")
    ret, out, err = ssh_key_exec(install_cmd)
    if ret != 0:
        print(f"!! Pacman output:\n{out}\n{err}")
    else:
        print("   Packages installed successfully!")

    print(">> Step 6: Updating GRUB boot configuration...")
    ssh_key_exec("sudo grub-mkconfig -o /boot/grub/grub.cfg")

    print(">> Step 7: Configuring Hyprland symlinks & launch helper...")
    symlink_cmd = (
        "mkdir -p ~/.config && "
        "rm -rf ~/.config/hypr && "
        "ln -s /home/arch/slaytheland/hypr ~/.config/hypr"
    )
    ssh_key_exec(symlink_cmd)

    autostart_cmd = (
        "cat << 'EOF' > ~/start-slaytheland.sh\n"
        "#!/bin/bash\n"
        "export XDG_CURRENT_DESKTOP=Hyprland\n"
        "export XDG_SESSION_TYPE=wayland\n"
        "export XDG_SESSION_DESKTOP=Hyprland\n"
        "exec Hyprland\n"
        "EOF\n"
        "chmod +x ~/start-slaytheland.sh"
    )
    ssh_key_exec(autostart_cmd)

    # Configure auto-login on tty1
    autologin_cmd = (
        "sudo mkdir -p /etc/systemd/system/getty@tty1.service.d && "
        "cat << 'EOF' | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf\n"
        "[Service]\n"
        "ExecStart=\n"
        "ExecStart=-/sbin/agetty -o '-p -f -- \\\\u' --noclear --autologin arch %I $TERM\n"
        "EOF\n"
        "sudo systemctl daemon-reload"
    )
    ssh_key_exec(autologin_cmd)

    # In ~/.bash_profile, automatically launch Hyprland if on tty1
    bash_profile_cmd = (
        "cat << 'EOF' >> ~/.bash_profile\n"
        "if [ -z \"$WAYLAND_DISPLAY\" ] && [ \"$XDG_VTNR\" -eq 1 ]; then\n"
        "    exec Hyprland\n"
        "fi\n"
        "EOF"
    )
    ssh_key_exec(bash_profile_cmd)

    print("\n=======================================================")
    print("  slaytheland VM Provisioning Complete!")
    print("=======================================================")

if __name__ == "__main__":
    main()
