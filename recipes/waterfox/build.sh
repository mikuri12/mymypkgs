#!/bin/bash
# waterfox 6.7.8 — tarball plano con dir raiz 'waterfox/'.
# build-pkg.sh extrae en /tmp/build y hace cd al dir unico.
set -euo pipefail
cd /tmp/build/waterfox-*
install -d "$DESTDIR/usr/lib/waterfox" "$DESTDIR/usr/bin" \
           "$DESTDIR/usr/share/applications" \
           "$DESTDIR/usr/share/icons/hicolor/256x256/apps"
cp -a . "$DESTDIR/usr/lib/waterfox/"
cat > "$DESTDIR/usr/bin/waterfox" <<'WEOF'
#!/bin/sh
exec /usr/lib/waterfox/waterfox "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/waterfox"
cat > "$DESTDIR/usr/share/applications/waterfox.desktop" <<'DEOF'
[Desktop Entry]
Name=Waterfox
Comment=Navegador web privado (fork de Firefox)
Exec=/usr/bin/waterfox %u
Icon=waterfox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
DEOF
cp browser/chrome/icons/default/default256.png \
   "$DESTDIR/usr/share/icons/hicolor/256x256/apps/waterfox.png"
