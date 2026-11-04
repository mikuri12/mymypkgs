#!/bin/bash
# noctalia-greeter 1.7.0 — meson (C++20 greeter + C compositor wlroots 0.20).
# Instala binarios + scripts de setup; la config de greetd/PAM va en
# post-install (usuario greeter, /var/lib/noctalia-greeter, config.toml).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  ..
ninja
DESTDIR="$DESTDIR" ninja install

# scripts de setup del sistema (del repo, NO de src/packaging)
SRC=$(ls -d /tmp/build/noctalia-greeter-*/ | head -1)
install -v -d "$DESTDIR/usr/share/noctalia-greeter"
install -v -m755 "$SRC/scripts/"*.sh "$DESTDIR/usr/share/noctalia-greeter/" 2>/dev/null || true
install -v -m755 "$SRC/scripts/noctalia-greeter-session" "$DESTDIR/usr/bin/" 2>/dev/null || true
install -v -m755 "$SRC/scripts/noctalia-greeter-print-greetd-config" "$DESTDIR/usr/bin/" 2>/dev/null || true

# La config de greetd (/etc/greetd/config.toml), el PAM (/etc/pam.d/greetd)
# y el servicio runit (/etc/sv/greetd/run) los instala el paquete greetd;
# noctalia-greeter solo aporta binarios y scripts de setup.
