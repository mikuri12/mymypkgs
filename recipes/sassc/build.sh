#!/bin/bash
set -euo pipefail
cd /tmp/build
ar x "$(find . -maxdepth 2 -name '*.deb' | head -1)"
mkdir -p "$DESTDIR"
tar -xf data.tar.* -C "$DESTDIR" 2>/dev/null || tar -xf data.tar.zst -C "$DESTDIR"
