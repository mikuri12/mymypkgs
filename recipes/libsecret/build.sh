#!/bin/bash
# libsecret 0.21.7 — meson. Opciones REALES (meson_options.txt 0.21.7):
# introspection/gtk_doc/vapi/manpage/debugging/tpm2/pam = boolean;
# crypto = combo (libgcrypt|gnutls|disabled); bash_completion = feature.
# 'vala' NO existe → se usa vapi=false. crypto=disabled evita libgcrypt.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D introspection=false \
  -D vapi=false \
  -D gtk_doc=false \
  -D manpage=false \
  -D crypto=disabled \
  -D bash_completion=disabled \
  -D pam=false \
  -D tpm2=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
