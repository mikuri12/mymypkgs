#!/bin/bash
# tools/pkg-install.sh — PROTOTIPO de instalador (la referencia de mymy).
# USO: pkg-install.sh <paquete.tar.zst>   (corre como root en el sistema)
# Instalación en DOS PASOS: staging → chequeo de conflictos → mover.
set -euo pipefail

PKG=$1
[ -f "$PKG" ] || { echo "no existe $PKG"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "requiere root"; exit 1; }

STG=/var/lib/mymy/staging/.install-$$
DB=/var/lib/mymy/db
LOCK=/var/lib/mymy/lock
mkdir -p "$STG" "$DB"

# Bloqueo atómico (PLAN: mkdir)
if ! mkdir "$LOCK" 2>/dev/null; then
    echo "otra instancia de mymy corre (lock activo)"; exit 1
fi
trap 'rm -rf "$STG" "$LOCK"' EXIT

# 1) Verificar integridad del paquete
sha_line=$(tar --zstd -xOf "$PKG" .PKGINFO.toml >/dev/null 2>&1 || true)
zstd -t "$PKG"

# 2) Extraer a staging (NUNCA directo a /)
#    Rechazar rutas absolutas o con ..  (validación de seguridad)
tar --zstd -tf "$PKG" | while IFS= read -r f; do
    case "$f" in
        /../*|../*|*/../*|..) echo "RUTA MALICIOSA: $f"; exit 1 ;;
        /*) echo "RUTA ABSOLUTA (no permitida): $f"; exit 1 ;;
    esac
done
tar --zstd -xpf "$PKG" -C "$STG" --numeric-owner --keep-directory-symlink

# 3) Chequear conflictos con otros paquetes
conflict=0
while IFS= read -r f; do
    [ -e "/$f" ] || continue
    # ¿de quién es?
    if [ -f "$DB/.$f" ]; then
        echo "CONFLICTO: /$f ya pertenece a $(cat "$DB/.$f")"
        conflict=1
    fi
done < "$STG/.FILES"
[ $conflict -eq 0 ] || { echo "instalación abortada (conflictos)"; exit 1; }

# 4) Mover a / y registrar
while IFS= read -r f; do
    target="/$f"
    mkdir -p "$(dirname "$target")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        # archivo del sistema sin dueño: respaldar como .mymy-orig
        mv -v "$target" "${target}.mymy-orig" || true
    fi
    mv -v "$STG/$f" "$target"
    printf '%s\n' "$(basename "$PKG" .tar.zst)" > "$DB/.$f"
done < "$STG/.FILES"

# hooks post-install (PLAN: triggers)
if [ -x /etc/mymy/hooks/post-install ]; then
    /etc/mymy/hooks/post-install "$(basename "$PKG" .tar.zst)" || true
fi
if grep -qE '^/usr/lib/' "$STG/.FILES" 2>/dev/null; then
    ldconfig || true
fi

echo "OK: $(basename "$PKG") instalado"
