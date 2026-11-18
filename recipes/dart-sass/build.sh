#!/bin/bash
set -euo pipefail
cd /tmp/build
sassbin=$(find . -name sass -type f | head -1)
srcdir=$(dirname "$sassbin")
mkdir -p "$DESTDIR/usr/lib/dart-sass" "$DESTDIR/usr/bin"
cp -r "$srcdir/." "$DESTDIR/usr/lib/dart-sass/"
ln -sf /usr/lib/dart-sass/sass "$DESTDIR/usr/bin/sass"
