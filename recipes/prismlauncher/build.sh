#!/bin/bash
# PrismLauncher 11.1.1 Qt6 Portable — tarball PLANO (sin dir raíz): build-pkg lo
# copió a /tmp/build. Se instala a /usr/lib/prismlauncher y wrapper con JAVA_HOME.
set -euo pipefail
bin=$(find /tmp/build -maxdepth 1 -type f -name "PrismLauncher" -perm -u+x | head -1)
[ -n "$bin" ] || { echo "no está /tmp/build/PrismLauncher"; ls /tmp/build | head; exit 1; }
install -d "$DESTDIR/usr/lib/prismlauncher"
for e in PrismLauncher bin etc lib share shared manifest.txt portable.txt sharun; do
  [ -e "/tmp/build/$e" ] && cp -a "/tmp/build/$e" "$DESTDIR/usr/lib/prismlauncher/"
done
install -d "$DESTDIR/usr/bin"
cat > "$DESTDIR/usr/bin/prismlauncher" <<'EOF'
#!/bin/bash
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jdk21}"
export PATH="$JAVA_HOME/bin:$PATH"
exec /usr/lib/prismlauncher/PrismLauncher "$@"
EOF
chmod 0755 "$DESTDIR/usr/bin/prismlauncher"
