#!/bin/bash
# alsa-ucm-conf 1.2.14 — datos puros: ucm2 al share/alsa.
set -euo pipefail
install -v -d "$DESTDIR/usr/share/alsa"
tar -xjf alsa-ucm-conf-1.2.14.tar.bz2 --strip-components=1 \
    -C "$DESTDIR/usr/share/alsa" --wildcards '*/ucm' '*/ucm2' --keep-directory-symlink
