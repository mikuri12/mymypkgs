#!/bin/bash
# foot 1.27.0 — meson. Las deps (tllist, fcft, utf8proc) YA están extraídas
# en el cwd por build-pkg.sh (todas las sources del recipe.toml).
set -euo pipefail
STAGING="$DESTDIR"   # staging del paquete; deps van al chroot real
unset DESTDIR       # ninja/make install heredan el export del build-pkg

# tllist → chroot real (deps intermedias SIN DESTDIR: pkg-config debe
# verlas para el siguiente paso; el staging final solo lleva foot).
cd /tmp/build/tllist
meson setup --prefix=/usr build --buildtype=release
ninja -C build && ninja -C build install
cd ..

# utf8proc 2.10.0 usa CMAKE (no meson) — verificado contra el tarball
cd /tmp/build/utf8proc-2.10.0
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release       -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF ..
make -j"$(nproc)"
make install
cd ../..

# freetype 2.13.3 (BLFS 12.4) → chroot real
cd /tmp/build/freetype-2.13.3
meson setup --prefix=/usr build --buildtype=release -D tests=disabled
ninja -C build && ninja -C build install
cd ..

# fontconfig 2.17.1 (BLFS 12.4; sin docs, sin nls) → chroot real
cd /tmp/build/fontconfig-2.17.1
meson setup --prefix=/usr build --buildtype=release -D doc=disabled -D nls=disabled -D tests=disabled
ninja -C build && ninja -C build install
cd ..

# fcft (sin docs/examples) → chroot real (foot la linkea)
cd /tmp/build/fcft
meson setup --prefix=/usr build --buildtype=release -D examples=false
ninja -C build && ninja -C build install
cd ..

# foot mismo
cd /tmp/build/foot-1.27.0
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D docs=disabled -D man=disabled -D tests=disabled \
  -D server-name=foot ..
ninja
DESTDIR="$STAGING" ninja install
