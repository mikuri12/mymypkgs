#!/bin/bash
# mikucat-cursor — instala miku-cursor-linux/ como /usr/share/icons/Hatsune-Miku
# y crea index.theme si el repo no lo trae.
set -euo pipefail
srcdir=$(find /tmp/build -maxdepth 1 -type d -name "hatsune-miku*" | head -1)
[ -n "$srcdir" ] || { echo "no se extrajo el repo de cursores"; exit 1; }
theme="$srcdir/miku-cursor-linux"
[ -d "$theme" ] || theme=$(find "$srcdir" -maxdepth 2 -type d -name "cursors" -printf '%h\n' | head -1)
[ -n "$theme" ] && [ -d "$theme" ] || { echo "no hay dir de tema con cursors/"; ls "$srcdir"; exit 1; }
install -d "$DESTDIR/usr/share/icons/Hatsune-Miku"
cp -a "$theme/." "$DESTDIR/usr/share/icons/Hatsune-Miku/"
if [ ! -f "$DESTDIR/usr/share/icons/Hatsune-Miku/index.theme" ]; then
  cat > "$DESTDIR/usr/share/icons/Hatsune-Miku/index.theme" <<'EOF'
[Icon Theme]
Name=Hatsune-Miku
Comment=Hatsune Miku cursor theme
Inherits=whiteglass
EOF
fi
# default para X (Wayland usa XCURSOR_THEME/Hatsune-Miku vía env)
install -d "$DESTDIR/usr/share/icons/default"
cat > "$DESTDIR/usr/share/icons/default/index.theme" <<'EOF'
[Icon Theme]
Inherits=Hatsune-Miku
EOF
ls "$DESTDIR/usr/share/icons/Hatsune-Miku/cursors" 2>/dev/null | head -3
