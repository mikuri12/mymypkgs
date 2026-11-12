#!/bin/bash
# starship 1.25.1 — cargo offline con vendor inyectado por pkg-build.yml.
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path . --root "$DESTDIR/usr" --locked --offline --bins
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
