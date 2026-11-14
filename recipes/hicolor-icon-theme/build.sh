#!/bin/bash
set -euo pipefail
./configure --prefix=/usr
DESTDIR="$DESTDIR" make install
