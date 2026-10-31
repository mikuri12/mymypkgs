#!/bin/bash
# wireplumber 0.5.10 — meson. Sin systemd, sin docs, sin tests.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D systemd=disabled -D system-lua=disabled \
  -D doc=disabled -D tests=false \
  -D elogind=disabled \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
install -v -d "$DESTDIR/usr/share/mymy/user-services/wireplumber"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/wireplumber' \
  > "$DESTDIR/usr/share/mymy/user-services/wireplumber/run"
chmod 755 "$DESTDIR/usr/share/mymy/user-services/wireplumber/run"
