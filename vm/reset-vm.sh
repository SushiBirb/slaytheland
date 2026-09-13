#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISK="$DIR/slaytheland-disk.qcow2"
BASE="$DIR/arch-base.qcow2"

if [ ! -f "$BASE" ]; then
    echo "Base image not found at $BASE"
    exit 1
fi

echo ">> Resetting slaytheland VM disk overlay..."
rm -f "$DISK"
qemu-img create -f qcow2 -F qcow2 -b arch-base.qcow2 "$DISK"
echo ">> Fresh overlay created: $DISK (inherits 40GB virtual sparse space)"
