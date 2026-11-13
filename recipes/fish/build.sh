#!/bin/bash
# fish 4.9.3 — cmake; la parte Rust usa cargo offline con el vendor asset
# (pkg-build.yml inyecta /root/.cargo/config.toml al ver 'cargo' aquí).
set -euo pipefail
export CARGO_NET_OFFLINE=true
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cmake -S "$d" -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DWITH_MESSAGE_LOCALIZATION=OFF
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
rm -f "$DESTDIR/usr/.crates.toml" "$DESTDIR/usr/.crates2.json"
