#!/bin/bash
# tplay 0.10.0 — cargo build con red en el chroot (no hay vendor asset; el
# fallback sin --offline ya esta cubierto por build-pkg.sh). libmpv viene de
# mpv release 2 (-Dlibmpv=true, instala include/mpv + lib/libmpv.so).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
# ffmpeg-next 9 puede exigir pkg-config de libav*; ffmpeg ya esta en el chroot.
cargo build --release --locked 2>/dev/null || cargo build --release
install -d "$DESTDIR/usr/bin"
install -m 0755 target/release/tplay "$DESTDIR/usr/bin/tplay"
