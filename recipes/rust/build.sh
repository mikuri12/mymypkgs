#!/bin/bash
set -euo pipefail
cd /tmp/build
# el instalador oficial usa install.sh con --prefix; modo desatendido:
d=$(find . -maxdepth 1 -mindepth 1 -type d | head -1)
"$d/install.sh" --prefix="$DESTDIR/usr" --disable-ldconfig
# binarios sueltos en /usr/bin
mkdir -p "$DESTDIR/usr/bin"
for b in cargo rustc rustdoc; do ln -sf /usr/lib/rustlib/x86_64-unknown-linux-gnu/bin/$b "$DESTDIR/usr/bin/$b" 2>/dev/null || true; done
for b in cargo rustc; do [ -e "$DESTDIR/usr/bin/$b" ] || ln -sf /usr/bin/$b "$DESTDIR/usr/bin/$b"; done
