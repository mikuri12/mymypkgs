#!/bin/bash
# Helium 0.21.3.1 — tarball con dir helium-*/ con el binario.
set -euo pipefail
d=$(find /tmp/build -maxdepth 2 -type d -name 'helium*' ! -path /tmp/build | head -1)
[ -n "$d" ] || d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
install -d "$DESTDIR/usr/lib/helium"
cp -a "$d"/. "$DESTDIR/usr/lib/helium/"
install -d "$DESTDIR/usr/bin"
cat > "$DESTDIR/usr/bin/helium" <<'WEOF'
#!/bin/sh
exec /usr/lib/helium/helium --no-sandbox "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/helium"
