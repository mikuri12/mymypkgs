#!/bin/bash
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -mindepth 1 -type d | head -1)
cd "$d"
# meson.build:17 hace git rev-parse --short HEAD con check:true; el tarball de codeload
# no trae .git -> exit 128 (run 44287217775). Repo dummy con un commit vacio.
git init -q "$d"
git -C "$d" -c user.email=ci@local -c user.name=ci commit -q --allow-empty -m ci
meson setup build "$d" --prefix=/usr --buildtype=release
meson compile -C build
DESTDIR="$DESTDIR" meson install -C build
