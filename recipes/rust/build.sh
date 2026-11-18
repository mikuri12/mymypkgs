#!/bin/bash
set -euo pipefail
cd /tmp/build
# instalador oficial: --prefix=<dir> instala bin/{cargo,rustc,rustdoc} ahi
# (los symlinks a rustlib/.../bin rompian cargo: cargo no vive ahi)
d=$(find . -maxdepth 1 -mindepth 1 -type d | head -1)
"$d/install.sh" --prefix="$DESTDIR/usr" --disable-ldconfig --components=rustc,cargo,rust-std-x86_64-unknown-linux-gnu
test -x "$DESTDIR/usr/bin/cargo"
test -x "$DESTDIR/usr/bin/rustc"
