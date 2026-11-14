#!/bin/bash
# yazi 26.9.1 — workspace; el binario sale de yazi-fm.
# v26.9.1 mete [patch.crates-io] ratatui-core = git(yazi-rs/ratatui, branch
# fix_buffer_diff_wide_cells): el vendor asset (generado con 26.5.6) NO lo
# trae y ademas esta stale (anyhow 1.0.102 vs 1.0.104 del Cargo.lock) ->
# en offline cargo muere con "can't checkout ... offline mode" y en red
# moriria con "candidate versions found which didn't match" si el
# replace-with siguiera activo. Offline solo si hay vendored-sources; si
# falla, reintento con red QUITANDO el reemplazo del vendor (crates-io
# real + git patch). Precedente helix 97932b0.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
if grep -q "vendored-sources" /root/.cargo/config.toml 2>/dev/null; then
  export CARGO_NET_OFFLINE=true
  cargo install --path yazi-fm --root "$DESTDIR/usr" --locked --offline || {
    echo "==> offline fallo (git deps fuera del vendor); reintento con red SIN vendor"
    unset CARGO_NET_OFFLINE
    awk '
      /^\[source\.crates-io\]/ || /^\[source\.vendored-sources\]/ {skip=1; next}
      /^\[/ {skip=0}
      !skip
    ' /root/.cargo/config.toml > /root/.cargo/config.toml.net
    mv /root/.cargo/config.toml.net /root/.cargo/config.toml
    cargo install --path yazi-fm --root "$DESTDIR/usr" --locked
  }
else
  cargo install --path yazi-fm --root "$DESTDIR/usr" --locked
fi
# cargo install --root deja metadatos globales que chocan entre paquetes cargo
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
