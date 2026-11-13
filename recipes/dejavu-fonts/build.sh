#!/bin/bash
# DejaVu Fonts 2.37 — solo copiar los TTF.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/share/fonts/dejavu"
find "$d" -path "*/ttf/*.ttf" -exec install -m 0644 {} "$DESTDIR/usr/share/fonts/dejavu/" \;
ls "$DESTDIR/usr/share/fonts/dejavu" | wc -l
