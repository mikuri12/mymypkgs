#!/bin/bash
# noctalia v5.4.1 — meson (C++23, gcc del chroot). -Dtests=disabled (feature),
# -Djemalloc=disabled (feature auto; sin jemalloc en chroot → no aplica),
# -Dsystem_libraries=false (default: usa vendored third_party wuffs/luau/fzy/mcu),
# -Dnative_optimizations=false (march va por CFLAGS=-march=skylake).
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=disabled \
  -D jemalloc=disabled \
  -D system_libraries=false \
  -D native_optimizations=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
# config por defecto con el agente polkit deshabilitado (sin polkitd en runtime)
install -v -d "$DESTDIR/etc/xdg/noctalia"
printf '%s\n' \
  '[shell]' \
  'polkit_agent = false' \
  > "$DESTDIR/etc/xdg/noctalia/settings.toml" || true
