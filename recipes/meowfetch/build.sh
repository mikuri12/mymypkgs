#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
cargo build --release --locked 2>/dev/null || cargo build --release
mkdir -p "$DESTDIR/usr/bin"
cp target/release/meowfetch "$DESTDIR/usr/bin/"
