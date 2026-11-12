#!/bin/bash
# 7zip 26.04 — cmake (target 7zz). Se instala el binario 7zz en /usr/bin.
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j"$(nproc)"
install -Dm755 build/bin/7zz "$DESTDIR/usr/bin/7zz"
ln -sf 7zz "$DESTDIR/usr/bin/7z"
