#!/bin/bash
# wpa_supplicant 2.12 — build en el subdir wpa_supplicant/ del tarball.
# defconfig usa nl80211 vía pkg-config libnl-3.0 (paquete libnl ya en chroot).
set -euo pipefail
cd wpa_supplicant
cp defconfig .config
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
install -Dm 0644 wpa_supplicant.conf "$DESTDIR/etc/wpa_supplicant/wpa_supplicant.conf"
