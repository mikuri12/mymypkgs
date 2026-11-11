#!/bin/bash
# xdg-desktop-portal 1.18.3 — meson.
# Opciones VERIFICADAS contra meson_options.txt de 1.18.3:
#   flatpak-interfaces/libportal/geoclue/systemd/docbook-docs = feature
#   dbus-service-dir/flatpak-interfaces-dir/systemd-user-unit-dir/datarootdir
#     = string ; xmlto-flags = array
# (NO existen 'tests' ni 'introspection' en 1.18.3 → pasarlos aborta meson)
#
# Deps obligatorias verificadas en meson.build:101-114:
#   glib-2.0 (>=2.66), gio-2.0, gio-unix-2.0, json-glib-1.0, fuse3 (>=3.10),
#   gdk-pixbuf-2.0, libpipewire-0.3 (>=0.2.90)
#   → el chroot ya tiene pipewire (instalado antes) y se añaden json-glib,
#     fuse3 y gdk-pixbuf como recetas propias.
# Opcionales: libportal (disabled), geoclue (disabled: sin geoclue en el
# chroot), systemd (disabled: el PLAN usa turnstile/runit), flatpak-interfaces
# (disabled: no hay flatpak), docbook-docs (disabled: no hay xmlto).
# sandboxed-image-validation = BOOLEAN (default true) en meson_options.txt 1.18.3: con true, meson.build:117 hace find_program(bwrap) obligatorio y el build falla (pkg-xdg-desktop-portal 43080477047/43087640170/43092939680, packages 43080476644/43085952950/43092812075). Con false no se exige bubblewrap en el chroot.
#
# Servicio de USUARIO (turnstile): /usr/share/mymy/user-services/...
# El .desktop de sesión lo pone Halley/Noctalia, no este paquete.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D flatpak-interfaces=disabled \
  -D libportal=disabled \
  -D geoclue=disabled \
  -D systemd=disabled \
  -D docbook-docs=disabled \
  -D sandboxed-image-validation=false \
  -D dbus-service-dir=/usr/share/dbus-1/services \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
# servicio de usuario turnstile (mismo patrón que pipewire/wireplumber)
install -v -d "$DESTDIR/usr/share/mymy/user-services/xdg-desktop-portal"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/xdg-desktop-portal' \
  > "$DESTDIR/usr/share/mymy/user-services/xdg-desktop-portal/run"
chmod 755 "$DESTDIR/usr/share/mymy/user-services/xdg-desktop-portal/run"
