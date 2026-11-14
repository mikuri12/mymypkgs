#!/bin/bash
# lm-sensors V3-6-2 — Makefile propio. build-pkg.sh entró en /tmp/build/lm-sensors-V3-6-2.
set -euo pipefail
make -j"$(nproc)" PREFIX=/usr
make PREFIX=/usr DESTDIR="$DESTDIR" install
