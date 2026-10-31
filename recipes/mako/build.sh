#!/bin/bash
# mako 1.3.10 — python (pip-less): meson-python vía setup. En chroot LFS
# sin pip: usar el build PEP 517 con python -m build no está; alternativa
# meson: mako 1.3.10 trae meson.build.
set -euo pipefail
SITE=$(python3 -c "import sysconfig; print(sysconfig.get_paths()["purelib"])")
install -d "$DESTDIR$SITE"
cp -r mako "$DESTDIR$SITE/"
python3 -m compileall -q "$DESTDIR$SITE/mako" || true
