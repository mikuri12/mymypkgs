#!/bin/bash
# pipewire 1.4.7 — meson. PLAN: sin systemd (sesión por turnstile), sin
# jack/jack2-dbus/docs. pipewire-pulse sí (PLAN lo pide).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D systemd=disabled \
  -D jack=disabled \
  -D docs=disabled -D man=disabled -D installed_tests=disabled \
  -D gstreamer=disabled -D bluez5=disabled -D vulkan=disabled \
  -D examples=disabled -D tests=disabled \
  -D session-managers=[] \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
# servicios de usuario RUNIT (PLAN: turnstile gestiona user-services;
# turnstile ejecuta runsvdir sobre ~/.local/runsvc/default)
install -v -d "$DESTDIR/usr/share/mymy/user-services/pipewire" \
              "$DESTDIR/usr/share/mymy/user-services/pipewire-pulse"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/pipewire' \
  > "$DESTDIR/usr/share/mymy/user-services/pipewire/run"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/pipewire-pulse' \
  > "$DESTDIR/usr/share/mymy/user-services/pipewire-pulse/run"
chmod 755 "$DESTDIR/usr/share/mymy/user-services"/*/run
