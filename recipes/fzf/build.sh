#!/bin/bash
# fzf 0.75.0 — go build (main en la raíz del repo).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
CGO_ENABLED=0 go build -trimpath -o fzf .
install -Dm755 fzf "$DESTDIR/usr/bin/fzf"
