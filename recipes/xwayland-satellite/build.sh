#!/bin/bash
# xwayland-satellite 0.6 — cargo. Vendor offline (chroot sin red): el workflow
# inyecta halley-vendor.tar.gz en /sources/<pkg>-vendor y .cargo/config.toml.
set -euo pipefail
export CARGO_INCREMENTAL=0
export CARGO_NET_OFFLINE=true
cargo build --release --locked --offline
install -v -D -m755 target/release/xwayland-satellite "$DESTDIR/usr/bin/xwayland-satellite"
