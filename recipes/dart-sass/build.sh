#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
mkdir -p "$DESTDIR/usr/bin"
cp "$d/dart-sass/sass" "$DESTDIR/usr/bin/sass"
chmod +x "$DESTDIR/usr/bin/sass"
