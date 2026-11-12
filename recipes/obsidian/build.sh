#!/bin/bash
# Obsidian — AppImage oficial (Electron). Se EXTRAE en el build con
# --appimage-extract (no necesita FUSE en runtime) y se instala en
# /usr/lib/obsidian + wrapper /usr/bin/obsidian. Fuente plana → cwd /tmp/build.
set -euo pipefail
src=$(find /tmp/build -maxdepth 1 -name "*__Obsidian-1.13.7.AppImage" -type f | head -1)
[ -n "$src" ] || { echo "falta el AppImage en /tmp/build"; exit 1; }
chmod +x "$src"
work=$(mktemp -d /tmp/obsx.XXXXXX)
trap 'rm -rf "$work"' EXIT
( cd "$work" && "$src" --appimage-extract >/dev/null 2>&1 )
root="$work/squashfs-root"
[ -d "$root" ] || { echo "appimage-extract falló"; exit 1; }
install -d "$DESTDIR/usr/lib/obsidian" "$DESTDIR/usr/bin" \
  "$DESTDIR/usr/share/applications" "$DESTDIR/usr/share/icons/hicolor/256x256/apps"
cp -a "$root/." "$DESTDIR/usr/lib/obsidian/"
cat > "$DESTDIR/usr/bin/obsidian" <<'EOF'
#!/bin/sh
exec /usr/lib/obsidian/AppRun "$@"
EOF
chmod 0755 "$DESTDIR/usr/bin/obsidian"
if [ -f "$DESTDIR/usr/lib/obsidian/obsidian.png" ]; then
  install -m 0644 "$DESTDIR/usr/lib/obsidian/obsidian.png" \
    "$DESTDIR/usr/share/icons/hicolor/256x256/apps/obsidian.png"
fi
cat > "$DESTDIR/usr/share/applications/obsidian.desktop" <<'EOF'
[Desktop Entry]
Name=Obsidian
Comment=Base de conocimiento en Markdown (local-first)
Exec=obsidian %U
Icon=obsidian
Type=Application
Categories=Office;
StartupWMClass=obsidian
EOF
