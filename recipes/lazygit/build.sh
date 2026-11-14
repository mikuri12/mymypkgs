#!/bin/bash
# lazygit 0.66.3 — go build (main en la raíz).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -X main.version=0.66.3" -o lazygit .
install -Dm755 lazygit "$DESTDIR/usr/bin/lazygit"
