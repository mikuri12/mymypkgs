#!/bin/bash
# seatd 0.9.3 (libseat+seatd) — meson; sin manpages (scdoc).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release -D man-pages=disabled -D benchmarks=disabled -D examples=disabled ..
ninja
DESTDIR="$DESTDIR" ninja install
# servicio runit (PLAN: seatd como servicio del sistema)
install -v -d "$DESTDIR/etc/sv/seatd"
printf '%s\n' '#!/bin/sh' 'exec seatd -g video' > "$DESTDIR/etc/sv/seatd/run"
chmod 755 "$DESTDIR/etc/sv/seatd/run"
