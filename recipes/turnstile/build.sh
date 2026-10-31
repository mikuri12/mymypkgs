#!/bin/bash
# turnstile 0.1.11 — meson: backend RUNIT (PLAN), sin dinit, con lib+pam.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D dinit=disabled -D runit=enabled \
  -D default_backend=runit \
  -D man=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
# servicio runit del sistema para turnstiled (patrón void-runit)
install -v -d "$DESTDIR/etc/sv/turnstiled"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/turnstiled' > "$DESTDIR/etc/sv/turnstiled/run"
chmod 755 "$DESTDIR/etc/sv/turnstiled/run"
