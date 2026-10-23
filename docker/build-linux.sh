#!/usr/bin/env bash
# Build a 64-bit Linux GorillasEX ELF without launching a GUI.
set -Eeuo pipefail

if [[ ! -f /project/src/gorillas.bas ]]; then
    echo 'ERROR: /project/src/gorillas.bas not found. Mount the GorillasEX root at /project.' >&2
    exit 2
fi

mkdir -p /project/bin
rm -f /project/bin/GorillasEX-linux-x86_64

# Keep the source directory as the working directory for existing INCLUDE paths.
cd /project/src
/opt/qb64pe/qb64pe -x gorillas.bas -o /project/bin/GorillasEX-linux-x86_64

test -s /project/bin/GorillasEX-linux-x86_64
chmod +x /project/bin/GorillasEX-linux-x86_64

# ELF check, not an attempt to launch a graphical game inside Docker.
file /project/bin/GorillasEX-linux-x86_64
readelf -h /project/bin/GorillasEX-linux-x86_64 | grep -E 'Class:|Machine:|Type:'
sha256sum /project/bin/GorillasEX-linux-x86_64 > /project/bin/GorillasEX-linux-x86_64.sha256
printf '\nBuild succeeded: bin/GorillasEX-linux-x86_64\n'
