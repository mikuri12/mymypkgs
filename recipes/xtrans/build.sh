#!/bin/bash
set -euo pipefail
[ -f configure ] || autoreconf -fi
./configure --prefix=/usr
DESTDIR="$DESTDIR" make install
