#!/bin/bash
# polkit 126 — meson. SOLO libs de agente (polkit-agent-1, polkit-gobject-1):
# AVISO (PLAN Fase 2 paso 6): Noctalia v5 NO tiene opción de build para
# desactivar polkit — dependency('polkit-agent-1') es required. Compilamos
# solo las libs de agente; el agente en runtime queda deshabilitado por
# config (polkit_agent = false en settings).
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D libs-only=true \
  -D tests=false -D introspection=false -D gtk_doc=false \
  -D man=false -D examples=false -D gettext=false \
  -D session_tracking=ConsoleKit -D authfw=shadow -D os_type=lfs \
  -D systemdsystemunitdir=no \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
