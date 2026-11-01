#!/bin/bash
# cargo-c 0.10.26 — binarios precompilados (musl estático, sin deps) del release
# oficial (cargo 0.100 embebido → soporta edition2024). Se instalan los 4 helpers que librsvg 2.61+ busca (cargo-cbuild).
set -euo pipefail
for b in cargo-capi cargo-cbuild cargo-cinstall cargo-ctest; do
  install -v -D -m755 "$b" "$DESTDIR/usr/bin/$b"
done
install -v -d "$DESTDIR/usr/share/cargo-c"
