#!/bin/bash
# Vesktop 1.6.9 — tarball plano (Vesktop-linux-x64/) con el binario Electron.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/lib/vesktop"
cp -a "$d"/. "$DESTDIR/usr/lib/vesktop/"
install -d "$DESTDIR/usr/bin"
cat > "$DESTDIR/usr/bin/vesktop" <<'WEOF'
#!/bin/sh
exec /usr/lib/vesktop/vesktop --no-sandbox "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/vesktop"
chmod 755 "$DESTDIR/usr/lib/vesktop/vesktop" 2>/dev/null || true
