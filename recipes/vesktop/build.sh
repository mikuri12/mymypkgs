#!/bin/bash
# Vesktop 1.6.9 — tar.gz oficial (app electron "linux-unpacked" en la raíz).
# build-pkg.sh extrajo el tarball y puso el cwd en /tmp/build/vesktop-1.6.9.
set -euo pipefail
install -d "$DESTDIR/usr/lib/vesktop" "$DESTDIR/usr/bin" \
  "$DESTDIR/usr/share/applications" "$DESTDIR/usr/share/icons/hicolor/256x256/apps"
cp -a . "$DESTDIR/usr/lib/vesktop/"
cat > "$DESTDIR/usr/bin/vesktop" <<'EOF'
#!/bin/sh
# --no-sandbox: el sandbox de Chromium necesita setuid o userns no trivial en LFS
exec /usr/lib/vesktop/vencorddesktop --no-sandbox "$@"
EOF
chmod 0755 "$DESTDIR/usr/bin/vesktop"
cat > "$DESTDIR/usr/share/applications/vesktop.desktop" <<'EOF'
[Desktop Entry]
Name=Vesktop
Comment=Cliente Discord de escritorio (Vencord)
Exec=vesktop %U
Icon=vesktop
Type=Application
Categories=Network;Chat;
EOF
icon=$(find . -maxdepth 3 -name "*.png" | head -1)
if [ -n "$icon" ]; then
  install -m 0644 "$icon" "$DESTDIR/usr/share/icons/hicolor/256x256/apps/vesktop.png"
fi
