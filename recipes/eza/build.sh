#!/bin/bash
# eza 0.23.4 — cargo offline. --no-default-features: la feature "git" tira de
# git2 -> libgit2-sys -> openssl-sys (sin openssl en el chroot). El vendor cubre
# todo el lock, así que compilar sin defaults sigue siendo offline.
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path . --root "$DESTDIR/usr" --locked --offline --no-default-features
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
