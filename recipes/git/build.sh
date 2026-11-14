#!/bin/bash
# git 2.54.0 — tarball de kernel.org YA trae `configure` generado (autoconf).
# build-pkg.sh entró en /tmp/build/git-2.54.0. Sin gettext (no hay msgfmt),
# sin tcltk. libcurl/expat/zlib/pcre2 ya instalados en el chroot.
set -euo pipefail
./configure --prefix=/usr --with-curl --with-expat \
  --with-openssl --with-zlib --without-tcltk
make -j"$(nproc)" NO_GETTEXT=YesPlease NO_TCLTK=YesPlease all
make NO_GETTEXT=YesPlease NO_TCLTK=YesPlease DESTDIR="$DESTDIR" install
