#!/bin/bash
# lua 5.4.8 — make plano (BLFS). Target linux (sin readline).
# Compila liblua.so compartida a mano (el Makefile solo genera liblua.a):
# wireplumber busca -llua dinámico vía pkg-config lua54.
set -euo pipefail
make linux
# shared lib: compilar objetos PIC y enlazar liblua.so.5.4.8
cd src
for o in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit; do
  cc -O2 -fPIC -DLUA_USE_LINUX -c $o.c -o $o.pic.o
done
cc -shared -Wl,-soname,liblua.so.5 -o liblua.so.5.4.8 *.pic.o -lm -ldl
ln -sf liblua.so.5.4.8 liblua.so.5
ln -sf liblua.so.5 liblua.so
cd ..
make INSTALL_TOP=/usr DESTDIR="$DESTDIR" install
install -m755 src/liblua.so.5.4.8 "$DESTDIR/usr/lib/liblua.so.5.4.8"
ln -sf liblua.so.5.4.8 "$DESTDIR/usr/lib/liblua.so.5"
ln -sf liblua.so.5 "$DESTDIR/usr/lib/liblua.so"
mkdir -p "$DESTDIR/usr/lib/pkgconfig"
printf "%s\n" "prefix=/usr" "exec_prefix=/usr" "libdir=/usr/lib" "includedir=/usr/include" "" "Name: lua" "Description: Lua 5.4" "Version: 5.4.8" "Libs: -L\${libdir} -llua -lm -ldl" "Cflags: -I\${includedir}" > "$DESTDIR/usr/lib/pkgconfig/lua54.pc"
