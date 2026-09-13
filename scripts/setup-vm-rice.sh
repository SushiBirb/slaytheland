#!/usr/bin/env bash
# Slaytheland Rice Setup Script (Runs inside the VM)
set -euo pipefail

echo "=================================================="
echo "  Setting up slaytheland Rice components in VM"
echo "=================================================="

echo ">> 1. Installing swaybg for wallpaper management..."
sudo pacman -S --needed --noconfirm swaybg

echo ">> 2. Installing Slay the Princess typography fonts..."
mkdir -p ~/.local/share/fonts
cp -v /home/arch/slaytheland/assets/fonts/*.ttf ~/.local/share/fonts/
fc-cache -fv

echo ">> 3. Linking Waybar, Wofi, Kitty, and Hyprland configurations..."
mkdir -p ~/.config
ln -sfn /home/arch/slaytheland/waybar ~/.config/waybar
ln -sfn /home/arch/slaytheland/wofi ~/.config/wofi
ln -sfn /home/arch/slaytheland/kitty ~/.config/kitty
ln -sfn /home/arch/slaytheland/hypr ~/.config/hypr

echo ">> 4. Linking SlayThePrincess cursor theme..."
mkdir -p ~/.local/share/icons
ln -sfn /home/arch/slaytheland/assets/icons/SlayThePrincess ~/.local/share/icons/SlayThePrincess

mkdir -p ~/.icons
ln -sfn /home/arch/slaytheland/assets/icons/SlayThePrincess ~/.icons/default

echo ">> 5. Setting default GTK cursor preferences..."
mkdir -p ~/.config/gtk-3.0
cat << 'EOF' > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-cursor-theme-name=SlayThePrincess
gtk-cursor-theme-size=32
gtk-font-name=Amatic SC 16
EOF

echo "=================================================="
echo "  slaytheland Rice Setup Complete!"
echo "=================================================="
