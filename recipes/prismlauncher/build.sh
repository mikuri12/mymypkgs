#!/bin/bash
# PrismLauncher 11.1.1 Qt6 Portable — extraer a /usr/lib/prismlauncher y
# wrapper /usr/bin/prismlauncher que fija JAVA_HOME=/usr/lib/jdk21.
set -euo pipefail
d=$(find /tmp/build -maxdepth 2 -type d ! -path /tmp/build | head -1)
bin=$(find "$d" -maxdepth 2 -type f -name "PrismLauncher" -perm -u+x | head -1)
[ -n "$bin" ] || { echo "no se encontró el binario PrismLauncher"; find "$d" -maxdepth 2 | head; exit 1; }
install -d "$DESTDIR/usr/lib/prismlauncher"
cp -a "$(dirname "$bin")/." "$DESTDIR/usr/lib/prismlauncher/"
install -d "$DESTDIR/usr/bin"
cat > "$DESTDIR/usr/bin/prismlauncher" <<'EOF'
#!/bin/bash
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jdk21}"
export PATH="$JAVA_HOME/bin:$PATH"
exec /usr/lib/prismlauncher/PrismLauncher "$@"
EOF
chmod 0755 "$DESTDIR/usr/bin/prismlauncher"
