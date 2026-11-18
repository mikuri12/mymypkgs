#!/bin/bash
set -euo pipefail
cd /tmp/build
d=$(find . -maxdepth 1 -mindepth 1 -type d | head -1)
mkdir -p "$DESTDIR/usr/lib/go"
cp -r "$d/go/." "$DESTDIR/usr/lib/go/"
mkdir -p "$DESTDIR/usr/bin"
for b in go gofmt; do ln -sf /usr/lib/go/bin/$b "$DESTDIR/usr/bin/$b"; done
