#!/bin/bash
# eza 0.23.5 — cargo. El vendor asset (generado con 0.23.4) esta stale vs el
# Cargo.lock de 0.23.5 (chrono 0.4.43 no esta en el vendor) -> offline muere con
# "failed to select a version". Offline solo si hay vendored-sources; si falla,
# reintento con red SIN vendor (config.toml vaciado, crates-io real).
# Patron yazi 9e37b35 / helix 97932b0. --no-default-features: la feature "git"
# tira de git2 -> libgit2-sys -> openssl-sys (sin openssl en el chroot).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
if grep -q "vendored-sources" "$HOME/.cargo/config.toml" 2>/dev/null; then
  export CARGO_NET_OFFLINE=true
  cargo install --path . --root "$DESTDIR/usr" --locked --offline --no-default-features || {
    echo "==> offline fallo (vendor stale vs Cargo.lock); reintento con red SIN vendor"
    unset CARGO_NET_OFFLINE
    : > "$HOME/.cargo/config.toml"
    cargo install --path . --root "$DESTDIR/usr" --locked --no-default-features
  }
else
  cargo install --path . --root "$DESTDIR/usr" --locked --no-default-features
fi
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
