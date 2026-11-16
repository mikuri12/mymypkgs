#!/bin/bash
set -euo pipefail
f=$(find /tmp/build -maxdepth 1 -type f -name "*.deb" | head -1)
ar x "$f"
mkdir -p ex && tar -xf data.tar.* -C ex 2>/dev/null || tar -xf data.tar.zst -C ex
install -d "$DESTDIR/usr/lib/discord" "$DESTDIR/usr/bin"
cp -a ex/usr/* "$DESTDIR/usr/" 2>/dev/null || cp -a ex/opt/* "$DESTDIR/usr/lib/discord/"
[ -f "$DESTDIR/usr/bin/discord" ] || ln -sf "$DESTDIR/usr/lib/discord/discord" "$DESTDIR/usr/bin/discord" 2>/dev/null || true
