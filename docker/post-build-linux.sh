#!/usr/bin/env bash

# ============================================================
# GorillasEX - Linux Post-Build
# Adds the credits section to the ELF64 executable.
# ============================================================

set -euo pipefail

PROJECT_DIR="/project"
BIN_DIR="${PROJECT_DIR}/bin"

INPUT="${BIN_DIR}/GorillasEX-linux-x86_64"
OUTPUT="${BIN_DIR}/GorillasEX-linux-x86_64.tmp"
CREDITS="${PROJECT_DIR}/docs/CREDITS.txt"

# Validates required files.
test -f "${INPUT}"
test -f "${CREDITS}"

# Prevents duplicate sections.
if objdump -h "${INPUT}" | grep -qE '[[:space:]]\.credits[[:space:]]'; then
    echo "ERROR: .credits already exists."
    exit 1
fi

# Adds the custom ELF section.
objcopy \
    --add-section ".credits=${CREDITS}" \
    --set-section-flags ".credits=contents,readonly" \
    "${INPUT}" \
    "${OUTPUT}"

# Confirms that the section exists.
readelf -S "${OUTPUT}" | grep -F ".credits"

# Validates that the embedded bytes match the source.
objcopy --dump-section ".credits=${BIN_DIR}/credits-verify.tmp" "${OUTPUT}"

cmp "${CREDITS}" "${BIN_DIR}/credits-verify.tmp"

rm -f "${BIN_DIR}/credits-verify.tmp"

# Replaces the executable after successful validation.
chmod +x "${OUTPUT}"
mv -f "${OUTPUT}" "${INPUT}"

echo "GorillasEX Linux post-build completed successfully."