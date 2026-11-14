#!/bin/bash
# helix 25.07.1 — cargo install con vendor asset <pkg>-vendor.tar.gz cuando
# exista (offline); si no, red en chroot (el workflow ya lo asume).
# Sin auto-build de gramáticas (necesita red en build).
set -euo pipefail
export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1
OFFLINE=""
if [ -f /root/.cargo/config.toml ] && grep -q "vendored-sources" /root/.cargo/config.toml; then
  export CARGO_NET_OFFLINE=true
  OFFLINE="--offline"
fi
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d"
cargo install --path helix-term --locked $OFFLINE --root "$DESTDIR/usr"
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
