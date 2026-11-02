#!/bin/bash
# polkit 126 — meson. SOLO libs de agente (polkit-agent-1, polkit-gobject-1):
# -D daemon=false para no compilar polkitd (no lo usamos en runtime).
# AVISO (PLAN Fase 2 paso 6): Noctalia v5 NO tiene opción de build para
# desactivar polkit — dependency('polkit-agent-1') es required. Compilamos
# solo las libs de agente; el agente en runtime queda deshabilitado por
# config (polkit_agent = false en settings).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D daemon=false -D libs-only=true \
  -D tests=false -D introspection=disabled -D gtk_doc=false \
  -D man_pages=disabled -D examples=false \
  -D systemdsystemunitdir=no -D systemduserunitdir=no \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
