#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
mkdir -p "$DESTDIR/usr/bin" "$DESTDIR/usr/lib/dart-sass"
cp "$d/dart-sass/sass" "$DESTDIR/usr/bin/sass"
cp -r "$d/dart-sass/src" "$DESTDIR/usr/lib/dart-sass/"
chmod +x "$DESTDIR/usr/bin/sass"
