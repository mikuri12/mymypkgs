#!/bin/bash
# NetworkManager 1.56.0 — meson. Opciones conservadoras (nombres de meson_options
# de NM 1.5x); introspection es feature → disabled.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dintrospection=disabled -Dselinux=disabled -Dmodemmanager=disabled \
  -Dconcheck=disabled -Dovs=disabled -Dppp=disabled -Dbluez=disabled \
  -Dlibndp=disabled -Dnm_cloud_setup=false ..
ninja
DESTDIR="$DESTDIR" ninja install
