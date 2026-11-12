#!/bin/bash
# niri 26.04 — cargo offline; vendor asset niri-vendor.tar.gz (pkg-build.yml lo
# descarga e inyecta /root/.cargo/config.toml al ver 'cargo' en build.sh).
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path . --root "$DESTDIR/usr" --locked --offline
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
