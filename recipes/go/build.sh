#!/bin/bash
set -euo pipefail
cd /tmp/build
src=$(find . -maxdepth 2 -name go -type d | head -1)
mkdir -p "$DESTDIR/usr/lib/go" "$DESTDIR/usr/bin"
cp -r "$src/." "$DESTDIR/usr/lib/go/"
for b in go gofmt; do ln -sf /usr/lib/go/bin/$b "$DESTDIR/usr/bin/$b"; done
