#!/bin/bash
# dbus 1.16.2 — BLFS 12.4 (cmake): sin systemd, sin X, sin selinux.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release \
      -DDBUS_BUILD_TESTS=OFF \
      -DDBUS_DISABLE_ASSERT=ON \
      -DDBUS_ENABLE_X11_AUTOLAUNCH=OFF \
      -DENABLE_SYSTEMD=OFF \
      -W no ..
make
DESTDIR="$DESTDIR" make install
# Servicio runit del sistema (PLAN: dbus como servicio del sistema, sin systemd).
install -v -d "$DESTDIR/etc/sv/dbus"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/dbus-daemon --system --nofork' \
  > "$DESTDIR/etc/sv/dbus/run"
chmod 755 "$DESTDIR/etc/sv/dbus/run"
