#!/bin/bash
# Noto Color Emoji — fuente PLANA (TTF): build-pkg.sh la copia a
# /tmp/build/<pkg>__NotoColorEmoji.ttf y el cwd es /tmp/build.
set -euo pipefail
src=$(find /tmp/build -maxdepth 1 -name "*__NotoColorEmoji.ttf" -type f | head -1)
[ -n "$src" ] || { echo "falta NotoColorEmoji.ttf en /tmp/build"; exit 1; }
install -d "$DESTDIR/usr/share/fonts/noto"
install -m 0644 "$src" "$DESTDIR/usr/share/fonts/noto/NotoColorEmoji.ttf"
