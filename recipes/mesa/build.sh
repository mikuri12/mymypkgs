#!/bin/bash
# mesa 25.1.8 — BLFS 12.4.
# HARDWARE REAL: iGPU Intel HD 530 (Broadwell, Gfx8/Gen8) → el driver correcto
# es CROCUS (ELK compiler), NO iris (iris es para Gfx9+/Skylake+).
#
# Por qué NO iris: en mesa 25.x `with_driver_using_cl` (meson.build:834) incluye
# with_gallium_iris y with_intel_vk incondicionalmente → with_clc=true →
# dependency('libclc') → dependency('llvm') → clang + LLVMSPIRVLib. Eso exige
# LLVM/clang/libclc (la rama "solo si Mesa lo exige" del PLAN) y no es viable.
# Crocus usa el compilador ELK propio (src/intel/compiler/elk), SIN LLVM.
#
# Vulkan: la HD530 es Gen8 → sin Vulkan de Intel (anv no da soporte para
# Broadwell). Se deja vulkan-drivers vacío.
#
# Plataformas: solo wayland; glx=disabled (sin x11, meson.build:555 exige x11
# para GLX; xwayland-satellite no usa GLX).
set -euo pipefail
rm -rf build && rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D platforms=wayland \
  -D glx=disabled \
  -D gallium-drivers=crocus \
  -D vulkan-drivers= \
  -D vulkan-layers= \
  -D gles1=disabled -D gles2=enabled \
  -D opengl=true -D egl=enabled -D gbm=enabled \
  -D llvm=disabled \
  -D mesa-clc=auto \
  -D precomp-compiler=system \
  -D intel-clc=auto \
  -D intel-elk=true \
  -D video-codecs=all_free \
  -D valgrind=disabled -D libunwind=disabled \
  -D shared-glapi=enabled \
  -D gallium-va=disabled -D gallium-vdpau=disabled \
  -D build-tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
