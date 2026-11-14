#!/bin/bash
# steam-launcher — instala el script lanzador (versionado en este repo) como
# /usr/bin/steam-launcher + desktop file. Fuente plana → cwd /tmp/build.
set -euo pipefail
src=$(find /tmp/build -maxdepth 1 -name "*__steam-launcher.sh" -type f | head -1)
[ -n "$src" ] || { echo "falta steam-launcher.sh en /tmp/build"; exit 1; }
install -d "$DESTDIR/usr/bin" "$DESTDIR/usr/share/applications"
install -m 0755 "$src" "$DESTDIR/usr/bin/steam-launcher"
ln -sf steam-launcher "$DESTDIR/usr/bin/steam"
cat > "$DESTDIR/usr/share/applications/steam.desktop" <<'EOF'
[Desktop Entry]
Name=Steam
Comment=Valve Steam (bootstrap oficial en primer arranque)
Exec=steam-launcher %U
Icon=steam
Type=Application
Categories=Game;
EOF
