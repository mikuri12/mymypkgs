#!/bin/bash
# tools/install-prebuilt.sh — Instala paquetes precompilados (tar.zst) en
# el chroot, en el orden de capas de tools/order.txt.
# USO (dentro del chroot): install-prebuilt.sh <dir-con-tar.zst>
#
# El nombre del paquete se saca quitando -<version>-<release> del nombre
# del archivo, y se compara EXACTO (glob wayland-* también matchea
# wayland-protocols-*; por eso no se usa glob de prefijo).
# Si hay varias versiones del mismo paquete, se instala la más alta.
set -euo pipefail

DIR=${1:-/prebuilt}
[ -d "$DIR" ] || { echo "no existe $DIR"; exit 1; }

ORDER=""
[ -f /tools/order.txt ] && ORDER=$(cat /tools/order.txt)

# 1) índice name -> archivo (el de versión más alta si hay varios)
declare -A BEST
for f in "$DIR"/*.tar.zst; do
  [ -e "$f" ] || continue
  b=$(basename "$f" .tar.zst)
  name=${b%-*-*}
  ver=${b#"$name"-}; ver=${ver%-*}
  if [ -z "${BEST[$name]:-}" ]; then
    BEST[$name]="$ver|$f"
  else
    cur=${BEST[$name]%%|*}
    if [ "$(printf '%s\n%s\n' "$cur" "$ver" | sort -V | tail -1)" = "$ver" ]; then
      BEST[$name]="$ver|$f"
    fi
  fi
done

install_one() {
  local name=$1 f=${BEST[$name]#*|}
  bash /tools/pkg-install.sh "$f"
}

installed=""
for p in $ORDER; do
  [ -n "${BEST[$p]:-}" ] || continue
  install_one "$p"
  installed="$installed $p"
done
# los que no estén en order.txt: al final, alfabético
for name in $(printf '%s\n' "${!BEST[@]}" | sort); do
  case " $installed " in *" $name "*) ;; *) install_one "$name"; installed="$installed $name" ;; esac
done
echo "==> prebuilt OK ($(printf '%s\n' "${!BEST[@]}" | wc -l) paquetes)"
