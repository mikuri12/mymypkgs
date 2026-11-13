#!/bin/bash
# helix 25.07.1 — cargo install offline con vendor (pkg-build inyecta config
# al ver 'cargo'). Sin auto-build de gramáticas (necesita red en build).
set -euo pipefail
export CARGO_NET_OFFLINE=true
export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path helix-term --locked --offline --root "$DESTDIR/usr"
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
