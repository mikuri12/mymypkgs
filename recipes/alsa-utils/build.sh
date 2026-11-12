#!/bin/bash
# alsa-utils 1.2.16 — autotools. Sin docs (xmlto) ni NLS para no exigir gettext.
set -euo pipefail
./configure --prefix=/usr --disable-xmlto --disable-nls
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
