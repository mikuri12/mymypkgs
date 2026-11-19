#!/bin/bash
# Equibop 3.3.4 — tarball plano (equibop-3.3.4/) con el binario Electron.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/lib/equibop" "$DESTDIR/usr/bin"
cp -a "$d"/. "$DESTDIR/usr/lib/equibop/"
cat > "$DESTDIR/usr/bin/equibop" <<'WEOF'
#!/bin/sh
exec /usr/lib/equibop/equibop --no-sandbox "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/equibop"
chmod 755 "$DESTDIR/usr/lib/equibop/equibop" 2>/dev/null || true
