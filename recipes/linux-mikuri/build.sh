#!/bin/bash
# linux-mikuri 7.1.5 — NO se compila (PLAN). Solo se extrae el tarball del
# release verificado (sha256 cf5fe270…) al staging con --keep-directory-symlink.
set -euo pipefail
SRC=$(ls /sources/linux-mikuri__mikuri-kernel-7.1.5-mikuri.tar.gz 2>/dev/null || ls /sources/*mikuri-kernel*.tar.gz | head -1)
rm -rf /tmp/build/linux-mikuri && mkdir -p /tmp/build/linux-mikuri
tar -xzpf "$SRC" -C /tmp/build/linux-mikuri --keep-directory-symlink
# el tarball trae boot/ y usr/lib/modules/ en la raíz → copiar tal cual al staging
cp -a /tmp/build/linux-mikuri/. "$DESTDIR/"
