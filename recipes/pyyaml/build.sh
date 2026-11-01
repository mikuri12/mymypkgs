#!/bin/bash
# pyyaml 6.0.2 - Python puro; el tarball de GitHub NO trae meson.build (PEP 517
# setuptools) y el paquete Python NO esta en la raiz del tarball: la raiz
# 'yaml/' solo tiene los .pyx/.pxd del modulo de extension C (_yaml.pyx) y NO
# tiene __init__.py -> 'import yaml' daba un namespace package vacio
# (unknown location) y 'from yaml import SafeLoader' fallaba en Mesa
# (run 41297279022). El paquete real esta en lib/yaml (setup.py:
# package_dir={'': 'lib'}, packages=['yaml','_yaml']).
# chroot LFS sin pip: copiar lib/yaml a site-packages + compileall.
set -euo pipefail
SITE=$(python3 -c "import sysconfig; print(sysconfig.get_path(chr(112)+chr(117)+chr(114)+chr(101)+chr(108)+chr(105)+chr(98)))")
install -d "$DESTDIR$SITE"
cp -r lib/yaml "$DESTDIR$SITE/yaml"
cp -r lib/_yaml "$DESTDIR$SITE/_yaml"
python3 -m compileall -q "$DESTDIR$SITE/yaml" "$DESTDIR$SITE/_yaml" || true
