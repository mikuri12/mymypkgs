#!/bin/bash
# yazi 26.9.1 — workspace; el binario sale de yazi-fm.
# v26.9.1 mete [patch.crates-io] ratatui-core = git(yazi-rs/ratatui, branch
# fix_buffer_diff_wide_cells): el vendor asset (generado con 26.5.6) NO lo
# trae y no hay yazi-vendor-config.toml con el source git -> en offline cargo
# muere con "can't checkout ... you are in the offline mode".
# Offline solo si hay vendored-sources; si falla, reintento con red en el
# chroot (resolv.conf bind-monteado por el workflow; precedent helix 97932b0).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
if grep -q "vendored-sources" /root/.cargo/config.toml 2>/dev/null; then
  export CARGO_NET_OFFLINE=true
  cargo install --path yazi-fm --root "$DESTDIR/usr" --locked --offline || {
    echo "==> offline fallo (git deps fuera del vendor); reintento con red"
    unset CARGO_NET_OFFLINE
    cargo install --path yazi-fm --root "$DESTDIR/usr" --locked
  }
else
  cargo install --path yazi-fm --root "$DESTDIR/usr" --locked
fi
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
