#!/bin/bash
# Maple Mono NF 7.9 — el source es un .zip (NO tarball): build-pkg.sh lo copia
# plano a /tmp/build/<pkg>__MapleMono-NF-unhinted.zip (cwd=/tmp/build).
# unzip NO esta en el chroot base LFS; python3 si (stage2) -> zipfile.
set -euo pipefail
src=$(find /tmp/build -maxdepth 1 -name "*__MapleMono-NF-unhinted.zip" -type f | head -1)
[ -n "$src" ] || { echo "falta el zip en /tmp/build"; exit 1; }
install -d /tmp/mmnf
python3 -m zipfile -e "$src" /tmp/mmnf
install -d "$DESTDIR/usr/share/fonts/maple-mono-nf"
find /tmp/mmnf -name "*.ttf" -exec install -m 0644 {} "$DESTDIR/usr/share/fonts/maple-mono-nf/" \;
lic=$(find /tmp/mmnf -iname "LICENSE*" -o -iname "OFL*" | head -1)
[ -n "$lic" ] && install -m 0644 "$lic" "$DESTDIR/usr/share/fonts/maple-mono-nf/"
ls "$DESTDIR/usr/share/fonts/maple-mono-nf/" | head
