#!/bin/bash
# ripgrep 15.2.0 — cargo offline; el vendor asset ya está en /tmp/vendor y el
# config de source-replacement en /root/.cargo/config.toml (inyectado por pkg-build.yml).
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path . --root "$DESTDIR/usr" --locked --offline --bins
