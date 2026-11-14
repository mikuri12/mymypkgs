#!/bin/bash
set -euo pipefail
./configure --prefix=/usr --disable-legacy-svg
DESTDIR="$DESTDIR" make install
