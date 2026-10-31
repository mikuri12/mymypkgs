#!/bin/bash
# mesa 25.1.8 — BLFS 12.4. SOLO iris (gallium) + vulkan intel, SIN LLVM
# (PLAN Fase 2 paso 2: mesa solo con gallium iris + vulkan intel; LLVM solo
# si Mesa lo exige → NO: con -D gallium-drivers=iris -D vulkan-drivers=intel
# y -D llvm=disabled no se necesita LLVM/clang/libclc).
# Plataformas: wayland (x11 solo para compat; xwayland-satellite la usa).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D platforms=wayland,x11 \
  -D gallium-drivers=iris \
  -D vulkan-drivers=intel \
  -D vulkan-layers= \
  -D gles1=disabled -D gles2=enabled \
  -D opengl=true -D egl=enabled -D gbm=enabled \
  -D llvm=disabled \
  -D video-codecs=all_free \
  -D valgrind=disabled -D libunwind=disabled \
  -D shared-glapi=enabled \
  -D gallium-va=disabled -D gallium-vdpau=disabled \
  -D build-tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
