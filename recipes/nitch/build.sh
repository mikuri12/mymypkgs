#!/bin/bash
# nitch 0.1.6 — nim toolchain en /opt/nim (paquete nim). Sin nimble: nim c directo.
set -euo pipefail
export PATH="/opt/nim/bin:$PATH"
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
nim c -d:release --opt:speed --out:/tmp/build/nitch-bin src/nitch.nim
install -d "$DESTDIR/usr/bin"
install -m 0755 /tmp/build/nitch-bin "$DESTDIR/usr/bin/nitch"
