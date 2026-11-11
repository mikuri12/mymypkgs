#!/bin/bash
# libpng — autotools (los tarballs oficiales NO traen meson.build; verificado
# contra libpng-<version>.tar.xz de SourceForge). zlib ya esta instalado en el
# chroot (ORDER). El dir de extraccion depende de la version (el bump
# upstream cambia recipe.toml pero no el nombre del dir): glob, no hardcode.
set -euo pipefail
cd /tmp/build/libpng-*
./configure --prefix=/usr --disable-static
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
