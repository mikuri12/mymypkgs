#!/bin/bash
# mymy 0.1.0 — el gestor vive en mymy/mymy (fuera de recipes). Aquí solo se
# instala el binario + la clave pública de firma.
set -euo pipefail
install -v -D -m755 /tmp/build/mymy-repo/mymy/mymy "$DESTDIR/usr/bin/mymy"
install -v -D -m644 /tmp/build/mymy-repo/keys/mymy.pub "$DESTDIR/usr/share/mymy/mymy.pub"
install -v -d "$DESTDIR/var/lib/mymy" "$DESTDIR/var/cache/mymy"
