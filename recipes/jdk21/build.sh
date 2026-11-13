#!/bin/bash
# Temurin JDK 21.0.13+9 — binario: extraer a /usr/lib/jdk21 y symlinks clave.
set -euo pipefail
d=$(find /tmp/build -maxdepth 1 -type d -name "jdk-*" ! -path /tmp/build | head -1)
[ -n "$d" ] || { echo "no se extrajo el JDK"; ls /tmp/build; exit 1; }
install -d "$DESTDIR/usr/lib"
cp -a "$d" "$DESTDIR/usr/lib/jdk21"
install -d "$DESTDIR/usr/bin"
for b in java javac jar keytool; do
  ln -sf "/usr/lib/jdk21/bin/$b" "$DESTDIR/usr/bin/$b"
done
"$DESTDIR/usr/lib/jdk21/bin/java" -version 2>&1 | head -1 || true
