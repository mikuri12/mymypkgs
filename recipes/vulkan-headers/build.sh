#!/bin/bash
# Vulkan-Headers 1.4.368 — cmake (solo instala headers + pkg-config/cmake config).
set -euo pipefail
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build build -j"$(nproc)"
DESTDIR="$DESTDIR" cmake --install build
# Vulkan-Headers 1.4.368 NO instala vulkan.pc (solo cmake config) → lo creamos
# a mano (headers-only; la lib la da vulkan-loader). Sin él, los paquetes que
# hacen dependency('vulkan') (mangohud, libplacebo) caen a subproyecto wrap.
install -d "$DESTDIR/usr/lib/pkgconfig"
cat > "$DESTDIR/usr/lib/pkgconfig/vulkan.pc" <<'EOF'
prefix=/usr
libdir=/usr/lib
includedir=/usr/include

Name: Vulkan-Headers
Description: Vulkan header files (pkg-config stub; libvulkan viene de vulkan-loader)
Version: 1.4.368
Cflags: -I${includedir}
EOF
