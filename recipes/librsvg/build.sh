#!/bin/bash
# librsvg 2.61.1 — meson + cargo (el loader de SVG es Rust). Chroot sin red:
# vendor offline inyectado por el workflow (librsvg-vendor.tar.gz).
#
# LECCIÓN (run 41359490731): el plugin cargo-cbuild EMBEBA su propia versión de
# cargo (no usa el del PATH). cargo-c 0.10.0 embebía cargo 0.80 (= Rust 1.79),
# que NO soporta edition2024 → error al parsear pxfm-0.1.20/Cargo.toml.
# Solución: cargo-c 0.10.26 (embebe cargo 0.100) + CARGO/CARGO_C_CARGO/RUSTC
# apuntando al rust 1.99.1 de /opt/rust.
set -euo pipefail
export CARGO_INCREMENTAL=0
export CARGO_NET_OFFLINE=true
export CARGO=/opt/rust/bin/cargo
export CARGO_C_CARGO=/opt/rust/bin/cargo
export RUSTC=/opt/rust/bin/rustc

mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D introspection=disabled -D vala=disabled -D docs=disabled \
  -D tests=false -D pixbuf=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
