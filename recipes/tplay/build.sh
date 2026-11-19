#!/bin/bash
# tplay 0.9.3 — cargo build con red en el chroot (no hay vendor asset; el
# fallback sin --offline ya esta cubierto por build-pkg.sh). libmpv viene de
# mpv 0.42 (-Dlibmpv, instala include/mpv + /usr/lib64/libmpv.so + mpv.pc).
# mpv instala en /usr/lib64 (meson libdir=lib64 en este rootfs) y ni lld ni
# collect2 la incluyen por defecto -> -lmpv falla en el link final
# (rust-lld: unable to find library -lmpv, run 44476730700). Se inyecta
# /usr/lib64 en LIBRARY_PATH (cc/collect2) y en RUSTFLAGS (link de rustc).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
export LIBRARY_PATH="/usr/lib64:/usr/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
export RUSTFLAGS="-L /usr/lib64 ${RUSTFLAGS:-}"
# ffmpeg-next puede exigir pkg-config de libav*; ffmpeg ya esta en el chroot.
cargo build --release --locked 2>/dev/null || cargo build --release
install -d "$DESTDIR/usr/bin"
install -m 0755 target/release/tplay "$DESTDIR/usr/bin/tplay"
