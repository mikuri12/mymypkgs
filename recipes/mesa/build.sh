#!/bin/bash
# mesa 25.1.8 — BLFS 12.4. SOLO iris (gallium) + vulkan intel, SIN LLVM
# (PLAN Fase 2 paso 2: mesa solo con gallium iris + vulkan intel; LLVM solo
# si Mesa lo exige → NO: con -D gallium-drivers=iris -D vulkan-drivers=intel
# y -D llvm=disabled + mesa-clc/precomp-compiler/intel-clc=system: con intel-bvh-grl=false (default) meson pone with_intel_clc=false y with_drivers_clc=false; con mesa-clc=system salta find_program(mesa_clc/vtn_bindgen2) (meson.build:841-844) y dependency(libclc) (meson.build:853) -> NO exige LLVMSPIRVLib/clang; los .cl de intel se precompilan con glslangValidator.
# Plataformas: wayland (x11 solo para compat; xwayland-satellite la usa).
set -euo pipefail
mkdir build && cd build
# Parche: compilar iris+anv SIN clc (mesa 25.1.8 no tiene flag limpio: con
# mesa-clc=system find_program(mesa_clc) es incondicional y src/intel/meson.build
# mete subdir(shaders) siempre con iris/intel_vk; ese subdir usa prog_mesa_clc y
# prog_vtn_bindgen2). Sin clc: los kernels .cl internos de compute quedan fuera;
# iris/anv compilan igual.
sed -i "s/prog_mesa_clc = find_program('mesa_clc', native : true)/prog_mesa_clc = find_program('mesa_clc', native : true, required : false)/" ../meson.build
sed -i "s/prog_vtn_bindgen2 = find_program('vtn_bindgen2', native : true)/prog_vtn_bindgen2 = find_program('vtn_bindgen2', native : true, required : false)/" ../meson.build
sed -i "s/^if with_intel_vk or with_gallium_iris$/if (with_intel_vk or with_gallium_iris) and prog_mesa_clc.found()/" ../src/intel/meson.build
# with_driver_using_cl incluye iris/intel_vk incondicionalmente (meson.build:834)
# → con mesa-clc=auto with_clc=true → exige dependency('libclc') (meson.build:854).
# Parche: forzar with_clc=false tras calcular with_driver_using_cl.
sed -i "s/^             with_drivers_clc or with_driver_using_cl$/             false/" ../meson.build
meson setup --prefix=/usr --buildtype=release \
  -D platforms=wayland,x11 \
  -D gallium-drivers=iris \
  -D vulkan-drivers=intel \
  -D vulkan-layers= \
  -D gles1=disabled -D gles2=enabled \
  -D opengl=true -D egl=enabled -D gbm=enabled \
  -D llvm=disabled \
  -D mesa-clc=auto \
  -D precomp-compiler=system \
  -D intel-clc=auto \
  -D video-codecs=all_free \
  -D valgrind=disabled -D libunwind=disabled \
  -D shared-glapi=enabled \
  -D gallium-va=disabled -D gallium-vdpau=disabled \
  -D build-tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install
