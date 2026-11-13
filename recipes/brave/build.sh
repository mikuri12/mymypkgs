#!/bin/bash
# Brave .deb → extraer data.tar.* con ar+tar (el chroot no tiene dpkg-deb).
set -euo pipefail
f=$(ls /sources/brave__*.deb 2>/dev/null | head -1)
[ -n "$f" ] || f=$(find /sources /tmp/build -maxdepth 2 -name '*.deb' 2>/dev/null | head -1)
mkdir -p /tmp/debx && cd /tmp/debx
ar x "$f"
dt=$(ls data.tar.* | head -1)
mkdir -p root && tar -xf "$dt" -C root
install -d "$DESTDIR/usr/lib/brave"
cp -a root/opt/brave.com/brave/. "$DESTDIR/usr/lib/brave/" 2>/dev/null || cp -a root/opt/brave/. "$DESTDIR/usr/lib/brave/"
install -d "$DESTDIR/usr/bin"
cat > "$DESTDIR/usr/bin/brave" <<'WEOF'
#!/bin/sh
exec /usr/lib/brave/brave --no-sandbox "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/brave"
ln -sf /usr/lib/brave/brave "$DESTDIR/usr/bin/brave-browser" 2>/dev/null || true
