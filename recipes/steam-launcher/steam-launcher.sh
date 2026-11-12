#!/bin/sh
# steam-launcher — instala el bootstrap OFICIAL de Valve en el primer arranque.
# Per PLAN Fase 4: Steam es propietario → NO se empaqueta ni se publica su binario;
# este lanzador solo descarga el .deb oficial de repo.steampowered.com y lo
# extrae en ~/.local/share/steam-bootstrap (usa ar+tar, sin dpkg).
# Requiere en el sistema: curl, binutils (ar), xz/zstd, tar (todos en la base).
set -eu
BOOT="${STEAM_BOOTSTRAP_DIR:-$HOME/.local/share/steam-bootstrap}"
if [ ! -x "$BOOT/usr/bin/steam" ]; then
  echo "==> descargando bootstrap oficial de Steam en $BOOT"
  mkdir -p "$BOOT"
  deb=$(mktemp /tmp/steam_latest.XXXXXX.deb)
  curl -fsSL -o "$deb" "https://repo.steampowered.com/steam/archive/precise/steam_latest.deb"
  d=$(mktemp -d /tmp/steamdeb.XXXXXX)
  ( cd "$d" && ar x "$deb" && tar -xf data.tar.* )
  cp -a "$d/usr" "$d/lib" "$d/share" "$BOOT/" 2>/dev/null || cp -a "$d/usr" "$BOOT/"
  rm -rf "$deb" "$d"
  echo "==> bootstrap instalado. El primer arranque descarga el cliente completo."
fi
exec "$BOOT/usr/bin/steam" "$@"
