#!/bin/bash
# acpid 2.0.34 — autotools (tarball release trae configure).
set -euo pipefail
./configure --prefix=/usr
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
