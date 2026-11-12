#!/bin/bash
# btop 1.4.7 — Makefile propio (sin cmake). build-pkg.sh ya entró en
# /tmp/build/btop-1.4.7 (dir raíz del tarball). El Makefile soporta DESTDIR.
set -euo pipefail
make -j"$(nproc)"
make DESTDIR="$DESTDIR" PREFIX=/usr install
