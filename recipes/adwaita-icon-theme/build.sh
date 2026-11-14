#!/bin/bash
# adwaita-icon-theme 47.0 — meson (47 ya no trae autotools), datos-only.
set -euo pipefail
# stub de gtk-update-icon-cache (meson lo exige; no hay gtk3 aún en el chroot)
printf '#!/bin/sh\nexit 0\n' > /usr/bin/gtk-update-icon-cache
chmod +x /usr/bin/gtk-update-icon-cache
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
meson setup build --prefix=/usr --buildtype=release "$d"
ninja -C build
DESTDIR="$DESTDIR" ninja -C build install
