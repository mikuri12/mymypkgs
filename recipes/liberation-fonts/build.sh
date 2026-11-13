#!/bin/bash
# Liberation Fonts 2.1.5 — solo copiar TTFs a /usr/share/fonts/truetype/liberation.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/share/fonts/truetype/liberation"
find "$d" -name '*.ttf' -exec install -m644 {} "$DESTDIR/usr/share/fonts/truetype/liberation/" \;
