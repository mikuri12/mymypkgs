#!/bin/bash
# nim 2.2.6 binario — layout nim-2.2.6/{bin,lib,config,...}; nim resuelve
# la stdlib como ../lib relativo al binario, asi que va a /opt/nim intacto.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
install -d "$DESTDIR/opt" "$DESTDIR/usr/bin"
cp -a "$d" "$DESTDIR/opt/nim"
ln -s /opt/nim/bin/nim "$DESTDIR/usr/bin/nim"
ln -s /opt/nim/bin/nimble "$DESTDIR/usr/bin/nimble"
