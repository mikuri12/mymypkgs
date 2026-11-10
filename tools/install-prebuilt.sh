#!/bin/bash
# tools/install-prebuilt.sh — Instala paquetes precompilados (tar.zst) en
# el chroot, en el orden de capas de tools/order.txt.
# USO (dentro del chroot): install-prebuilt.sh <dir-con-tar.zst>
set -euo pipefail

DIR=${1:-/prebuilt}
[ -d "$DIR" ] || { echo "no existe $DIR"; exit 1; }

ORDER=""
[ -f /tools/order.txt ] && ORDER=$(cat /tools/order.txt)

installed=""
for p in $ORDER; do
  for f in "$DIR/$p"-*.tar.zst; do
    [ -e "$f" ] || continue
    bash /tools/pkg-install.sh "$f"
    installed="$installed $p"
  done
done
# los que no estén en order.txt: al final, alfabético
for f in "$DIR"/*.tar.zst; do
  [ -e "$f" ] || continue
  b=$(basename "$f" .tar.zst)
  p=${b%-*-*}   # quita -<version>-<release> (wayland-protocols-1.49-1 -> wayland-protocols)
  case " $installed " in *" $p "*) ;; *) bash /tools/pkg-install.sh "$f"; installed="$installed $p" ;; esac
done
echo "==> prebuilt OK ($(ls "$DIR"/*.tar.zst 2>/dev/null | wc -l) paquetes)"
