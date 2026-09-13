#!/usr/bin/env bash
# ==============================================================================
# slaytheland Release Packager
# Packages a clean distribution archive adhering strictly to the hyprmilk model
# (excludes proprietary game assets, VM disks, and git metadata).
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

VERSION="${1:-1.0.0}"
DIST_DIR="${ROOT_DIR}/dist"
ARCHIVE_NAME="slaytheland-v${VERSION}"
TAR_PATH="${DIST_DIR}/${ARCHIVE_NAME}.tar.gz"

echo "================================================================================"
echo "                   slaytheland Release Packager — v${VERSION}"
echo "================================================================================"

mkdir -p "${DIST_DIR}"

echo "[*] Packaging clean release archive (excluding assets, VM disks, and git)..."

# Create archive from git archive if inside git repository, or tar with strict excludes
if git -C "${ROOT_DIR}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "  Using git archive export..."
    git -C "${ROOT_DIR}" archive \
        --format=tar.gz \
        --prefix="${ARCHIVE_NAME}/" \
        -o "${TAR_PATH}" \
        HEAD
else
    echo "  Using tar with exclusion filters..."
    tar --exclude-vcs \
        --exclude="assets" \
        --exclude="vm/*.qcow2" \
        --exclude="vm/*.img" \
        --exclude="dist" \
        -czf "${TAR_PATH}" \
        --transform="s,^,${ARCHIVE_NAME}/," \
        -C "${ROOT_DIR}" .
fi

# Calculate SHA256
SHA256=$(sha256sum "${TAR_PATH}" | awk '{print $1}')
echo "${SHA256}  ${ARCHIVE_NAME}.tar.gz" > "${DIST_DIR}/${ARCHIVE_NAME}.sha256"

FILE_SIZE=$(du -h "${TAR_PATH}" | cut -f1)

echo ""
echo "================================================================================"
echo "✓ Release package created successfully!"
echo "  Archive:  ${TAR_PATH} (${FILE_SIZE})"
echo "  Checksum: ${SHA256}"
echo "================================================================================"
