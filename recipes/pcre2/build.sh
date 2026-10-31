#!/bin/bash
# pcre2 10.45 — cmake (BLFS 12.4). Sin tests, sin pcre2grep, sin JIT.
set -euo pipefail
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_SHARED_LIBS=ON \
      -DPCRE2_BUILD_TESTS=OFF \
      -DPCRE2_BUILD_PCRE2GREP=OFF \
      -DPCRE2_BUILD_PCRE2POSIX=OFF \
      -DPCRE2_SUPPORT_JIT=OFF \
      -DPCRE2_SUPPORT_UNICODE=ON \
      ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
