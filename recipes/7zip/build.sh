#!/bin/bash
# 7zip 26.04 — el árbol fuente NO trae CMakeLists (el build cmake vive en otra
# rama); se compila con el makefile gcc del bundle Alone2 (7zz standalone).
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d ! -path /tmp/build | head -1)
cd "$d/CPP/7zip/Bundles/Alone2"
make -f makefile.gcc -j"$(nproc)"
bin=$(find "$d/CPP/7zip/Bundles/Alone2" -name 7zz -type f -perm -u+x | head -1)
[ -n "$bin" ] || { echo "no se encontró 7zz tras el build"; exit 1; }
install -Dm755 "$bin" "$DESTDIR/usr/bin/7zz"
ln -sf 7zz "$DESTDIR/usr/bin/7z"
