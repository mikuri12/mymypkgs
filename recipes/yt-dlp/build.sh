#!/bin/bash
# yt-dlp — binario oficial precompilado (PyInstaller). Fuente PLANA (no tarball):
# build-pkg.sh la copia a /tmp/build/<pkg>__yt-dlp_linux y el cwd es /tmp/build.
set -euo pipefail
src=$(find /tmp/build -maxdepth 1 -name "*__yt-dlp_linux" -type f | head -1)
[ -n "$src" ] || { echo "falta yt-dlp_linux en /tmp/build"; exit 1; }
install -d "$DESTDIR/usr/bin"
install -m 0755 "$src" "$DESTDIR/usr/bin/yt-dlp"
