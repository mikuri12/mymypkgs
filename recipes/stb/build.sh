#!/bin/bash
# stb (header-only) — solo copiar los headers que Noctalia exige:
# stb/stb_image_resize2.h y stb/stb_image_write.h
set -euo pipefail
SRC=$(ls -d /tmp/build/stb-*/ | head -1)
install -v -d "$DESTDIR/usr/include/stb"
install -v -m644 "$SRC/stb_image_resize2.h" "$DESTDIR/usr/include/stb/"
install -v -m644 "$SRC/stb_image_write.h" "$DESTDIR/usr/include/stb/"
install -v -m644 "$SRC/stb_image.h" "$DESTDIR/usr/include/stb/" 2>/dev/null || true
