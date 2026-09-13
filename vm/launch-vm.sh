#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$DIR/.." && pwd)"
DISK="$DIR/slaytheland-disk.qcow2"
BASE="$DIR/arch-base.qcow2"

if [ ! -f "$BASE" ]; then
    echo "Error: Base image not found at $BASE"
    exit 1
fi

if [ ! -f "$DISK" ]; then
    echo ">> Initializing new overlay disk..."
    "$DIR/reset-vm.sh"
fi

HEADLESS=false
for arg in "$@"; do
    if [ "$arg" == "--headless" ]; then
        HEADLESS=true
    fi
done

CPUS="${CPUS:-4}"
RAM="${RAM:-4G}"

EXTRA_ARGS=()
if [ "$HEADLESS" = true ]; then
    EXTRA_ARGS+=( -display none -serial mon:stdio )
else
    # GDK Wayland backend with hardware-accelerated OpenGL
    export GDK_BACKEND=wayland
    EXTRA_ARGS+=(
        -device virtio-vga-gl
        -display gtk,gl=on,show-menubar=off
        -device virtio-tablet-pci
        -device virtio-keyboard-pci
    )
fi

echo "========================================="
echo " Starting slaytheland Arch Linux VM"
echo "  - CPUs: $CPUS | RAM: $RAM"
echo "  - SSH port: localhost:2222"
echo "  - Shared folder: $PROJECT_ROOT"
echo "========================================="

rm -f /tmp/qemu-mon.sock
exec qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp "$CPUS" \
    -m "$RAM" \
    -drive file="$DISK",if=virtio,format=qcow2 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net-pci,netdev=net0 \
    -device virtio-rng-pci \
    -monitor unix:/tmp/qemu-mon.sock,server,nowait \
    -virtfs local,path="$PROJECT_ROOT",mount_tag=slaytheland,security_model=none,id=slaytheland \
    -audiodev pipewire,id=snd0 \
    -device intel-hda -device hda-duplex,audiodev=snd0 \
    "${EXTRA_ARGS[@]}"
