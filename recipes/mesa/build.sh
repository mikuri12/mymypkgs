#!/bin/bash
# mesa 24.0.9 — gallium iris + vulkan intel (anv) para Intel HD 530.
#
# HARDWARE REAL: OptiPlex 7050, i3-6100 (Skylake), iGPU Intel HD 530 = Gen9/9lp
# (verificado en el código fuente de mesa):
#   iris_screen.c:318  "return devinfo->ver >= 9;"  → iris soporta Gen9+
#   crocus_screen.c:731 "if (devinfo.ver > 8) return NULL;" → crocus SOLO Gen8
# ⇒ con crocus (lo que tenía antes) esta CPU se queda SIN aceleración 3D.
#   El driver correcto es IRIS + ANV.
#
# POR QUÉ 24.0.9 Y NO 25.x: en mesa 25.x meson.build:834
#   with_driver_using_cl = [with_gallium_iris, with_intel_vk, ...]
# → with_clc=true → dependency('libclc') → dependency('llvm') → clang+LLVMSPIRVLib.
# En mesa 24.0.9 meson.build:328
#   with_clc = with_microsoft_clc or with_intel_clc or with_gallium_asahi
# → iris/anv NO activan clc. Verificado también el bloque dep_llvm (línea 1749):
#   required = (with_amd_vk or with_gallium_radeonsi or with_gallium_opencl
#               or with_clc or _llvm.enabled())
#   → con iris+anv y llvm=disabled NO se busca LLVM en absoluto.
# intel-clc queda 'disabled' (default de 24.0.9) → sin intel-clc, sin RT.
#
# Opciones VERIFICADAS contra meson_options.txt de 24.0.9 (85 opciones):
#   platforms/gallium-drivers/vulkan-drivers/video-codecs/vulkan-layers = array
#   glx/intel-clc = combo ; llvm/gallium-va/gallium-vdpau/shared-glapi/
#   gles1/gles2/egl/gbm/valgrind/libunwind = feature
#   opengl/build-tests = boolean
# OJO: 'mesa-clc' y 'precomp-compiler' NO EXISTEN en 24.0.9 (sí en 25.x) →
# pasarlos aborta meson con "Unknown options".
#
# glslangValidator es obligatorio: meson.build:618 lo exige con with_intel_vk.
# Plataformas: solo wayland (xwayland-satellite es wayland puro, no usa GLX);
# glx=disabled porque con x11 meson exige x11 para GLX.
set -euo pipefail
rm -rf build && mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D platforms=wayland \
  -D glx=disabled \
  -D gallium-drivers=iris \
  -D vulkan-drivers=intel \
  -D vulkan-layers= \
  -D gles1=disabled -D gles2=enabled \
  -D opengl=true -D egl=enabled -D gbm=enabled \
  -D llvm=disabled \
  -D intel-clc=disabled \
  -D video-codecs=all_free \
  -D valgrind=disabled -D libunwind=disabled \
  -D shared-glapi=enabled \
  -D gallium-va=disabled -D gallium-vdpau=disabled \
  -D build-tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
