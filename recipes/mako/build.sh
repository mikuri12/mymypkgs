#!/bin/bash
# mako 1.3.10 — python (pip-less): meson-python vía setup. En chroot LFS
# sin pip: usar el build PEP 517 con python -m build no está; alternativa
# meson: mako 1.3.10 trae meson.build.
set -euo pipefail
SITE=$(python3 -c "import sysconfig; print(sysconfig.get_path(chr(112)+chr(117)+chr(114)+chr(101)+chr(108)+chr(105)+chr(98)))")
install -d "$DESTDIR$SITE"
cp -r mako "$DESTDIR$SITE/"
python3 -m compileall -q "$DESTDIR$SITE/mako" || true
