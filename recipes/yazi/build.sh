#!/bin/bash
# yazi 26.5.6 — workspace; el binario sale de yazi-fm. cargo offline con vendor.
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path yazi-fm --root "$DESTDIR/usr" --locked --offline
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
