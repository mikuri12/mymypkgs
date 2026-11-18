#!/bin/bash
set -euo pipefail
cd /tmp/build
sassbin=$(find . -name sass -type f | head -1)
srcdir=$(dirname "$sassbin")
mkdir -p "$DESTDIR/usr/bin" "$DESTDIR/usr/lib/dart-sass"
cp "$sassbin" "$DESTDIR/usr/bin/sass"
cp -r "$srcdir" "$DESTDIR/usr/lib/dart-sass/"
chmod +x "$DESTDIR/usr/bin/sass"
