#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
mkdir -p "$DESTDIR/usr/share/nwg-displays" "$DESTDIR/usr/bin"
cp -r "$d"/* "$DESTDIR/usr/share/nwg-displays/"
cat > "$DESTDIR/usr/bin/nwg-displays" <<'EOS'
#!/bin/sh
exec python3 /usr/share/nwg-displays/nwg_displays/main.py "$@"
EOS
chmod +x "$DESTDIR/usr/bin/nwg-displays"
