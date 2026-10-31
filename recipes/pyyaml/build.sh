#!/bin/bash
# pyyaml 6.0.2 — meson (6.0.2 trae meson.build para el módulo C opcional;
# sin libyaml compila el módulo puro Python).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR="$DESTDIR" ninja install
