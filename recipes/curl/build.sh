#!/bin/bash
# curl 8.23.0 — autotools/cmake. OpenSSL, sin brotli/nghttp3 extra.
set -euo pipefail
rm -rf build && mkdir build && cd build
cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DCURL_USE_OPENSSL=ON \
  -DCURL_DISABLE_BROTLI=ON -DCURL_USE_LIBPSL=OFF -DCURL_DISABLE_LDAPS=ON -DCURL_DISABLE_LDAP=ON \
  ..
make -j"$(nproc)"
DESTDIR="$DESTDIR" make install
