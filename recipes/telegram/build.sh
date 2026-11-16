#!/bin/bash
set -euo pipefail
f=$(find /tmp/build -maxdepth 1 -type f -name "*.tar.*" | head -1)
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d" 2>/dev/null || true
install -d "$DESTDIR/usr/lib/telegram-desktop" "$DESTDIR/usr/bin"
cp -a "$d"/. "$DESTDIR/usr/lib/telegram-desktop/" 2>/dev/null || { mkdir -p ex && tar -xf "$f" -C ex && cp -a ex/Telegram/* "$DESTDIR/usr/lib/telegram-desktop/"; }
cat > "$DESTDIR/usr/bin/telegram-desktop" <<'WEOF'
#!/bin/sh
exec /usr/lib/telegram-desktop/Telegram -- "$@"
WEOF
chmod 755 "$DESTDIR/usr/bin/telegram-desktop"
