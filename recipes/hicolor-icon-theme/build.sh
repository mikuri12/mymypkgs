#!/bin/bash
# hicolor-icon-theme 0.18 — solo datos; copiar a /usr/share/icons/hicolor.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/share/icons/hicolor"
cp -a "$d"/. "$DESTDIR/usr/share/icons/hicolor/"
