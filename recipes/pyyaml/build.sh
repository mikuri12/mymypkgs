#!/bin/bash
# pyyaml 6.0.2 — Python puro; tarball 6.0.2 NO trae meson.build (PEP 517 setuptools).
# chroot LFS sin pip: copiar yaml/ a site-packages + compileall.
set -euo pipefail
SITE=$(python3 -c "import sysconfig; print(sysconfig.get_path(chr(112)+chr(117)+chr(114)+chr(101)+chr(108)+chr(105)+chr(98)))")
install -d "$DESTDIR$SITE"
cp -r yaml "$DESTDIR$SITE/"
python3 -m compileall -q "$DESTDIR$SITE/yaml" || true
