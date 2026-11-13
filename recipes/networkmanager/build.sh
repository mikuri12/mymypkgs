#!/bin/bash
# NetworkManager 1.56.0 — meson. En NM 1.5x varias opciones pasaron a boolean
# (introspection/selinux/concheck/ovs/ppp/modem_manager; modemmanager reenombrado
# a modem_manager): "disabled" ya no vale en boolean (usar false), y bluez/
# libndp ya no existen como opcion (bluez5_dun es la unica). SysV sin systemd
# ni nss/gnutls en la base: session_tracking=no, systemd_journal=false, crypto=null.
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -Dintrospection=false -Dselinux=false -Dmodem_manager=false \
  -Dconcheck=false -Dovs=false -Dppp=false -Dbluez5_dun=false \
  -Dnm_cloud_setup=false -Dsession_tracking=no -Dsystemd_journal=false \
  -Dsystemdsystemunitdir=no \
  -Dcrypto=null -Dlibpsl=false -Dlibaudit=no -Dqt=false -Dman=false -Dtests=no -Dnmtui=false ..
ninja
DESTDIR="$DESTDIR" ninja install
