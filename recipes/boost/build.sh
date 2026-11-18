#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
./bootstrap.sh --prefix="$DESTDIR/usr" --with-libraries=all
./b2 -j"$(nproc)" variant=release link=shared,static threading=multi install --prefix="$DESTDIR/usr"
