#!/bin/bash
# DejaVu Fonts 2.37 — el tag de git NO trae los TTF; se usa el ZIP oficial de
# SourceForge (plano en /tmp/build; el chroot no tiene unzip → python3 zipfile).
set -euo pipefail
z=$(find /tmp/build -maxdepth 1 -name "*dejavu-fonts-ttf-*.zip" | head -1)
[ -n "$z" ] || { echo "falta el zip en /tmp/build"; ls /tmp/build; exit 1; }
rm -rf /tmp/dejavu && mkdir -p /tmp/dejavu
python3 -m zipfile -e "$z" /tmp/dejavu
install -d "$DESTDIR/usr/share/fonts/dejavu"
find /tmp/dejavu -name "*.ttf" -exec install -m 0644 {} "$DESTDIR/usr/share/fonts/dejavu/" \;
ls "$DESTDIR/usr/share/fonts/dejavu" | wc -l
