#!/bin/bash
set -euo pipefail
f=$(find /tmp/build -maxdepth 1 -type f -name "*.deb" | head -1)
ar x "$f"
mkdir -p ex && tar -xf data.tar.* -C ex 2>/dev/null || tar -xf data.tar.zst -C ex
install -d "$DESTDIR/usr/lib/spotify" "$DESTDIR/usr/bin"
cp -a ex/usr/* "$DESTDIR/usr/" 2>/dev/null || cp -a ex/opt/* "$DESTDIR/usr/lib/spotify/"
[ -f "$DESTDIR/usr/bin/spotify" ] || ln -sf "$DESTDIR/usr/lib/spotify/spotify" "$DESTDIR/usr/bin/spotify" 2>/dev/null || true
