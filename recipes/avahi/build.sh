#!/bin/bash
# avahi 0.8 — autotools. Solo el core (sin GUI/Qt/Python/mono).
set -euo pipefail
# tarball oficial del release: trae ./configure pre-generado
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  --disable-static \
  --disable-qt3 --disable-qt4 --disable-qt5 --disable-qt6 \
  --disable-gtk --disable-gtk3 --disable-glib --disable-gobject \
  --disable-python --disable-mono --disable-monodoc \
  --disable-doxygen-doc --disable-doxygen-html --disable-xmltoman --disable-lynx \
  --enable-compat-libdns_sd --enable-compat-howl \
  --with-distro=none \
  --with-avahi-user=avahi --with-avahi-group=avahi \
  --with-systemdsystemunitdir=no
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
