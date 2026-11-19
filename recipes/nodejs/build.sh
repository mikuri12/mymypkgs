#!/bin/bash
# nodejs — binario oficial linux-x64. Layout: bin/ include/node lib/node_modules share/.
# Se copia a /usr preservando symlinks relativos (npm -> ../lib/node_modules/...).
# Sin docs (share/doc), PLAN.
set -euo pipefail
cd /tmp/build/node-*-linux-x64
install -d "$DESTDIR/usr"
cp -a bin include lib "$DESTDIR/usr/"
cp -a share "$DESTDIR/usr/"
rm -rf "$DESTDIR/usr/share/doc"
