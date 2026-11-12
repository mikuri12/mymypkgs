#!/bin/bash
# cliphist 0.7.0 — go build (main en la raíz del repo).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
CGO_ENABLED=0 go build -trimpath -o cliphist .
install -Dm755 cliphist "$DESTDIR/usr/bin/cliphist"
