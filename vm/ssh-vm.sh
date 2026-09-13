#!/usr/bin/env bash
# Quick SSH connector into the slaytheland VM
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY="$DIR/id_ed25519"

ARGS=(
    -p 2222
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
    -o LogLevel=ERROR
)

if [ -f "$KEY" ]; then
    ARGS+=( -i "$KEY" )
fi

exec ssh "${ARGS[@]}" arch@localhost "$@"
