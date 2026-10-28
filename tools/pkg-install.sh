#!/bin/bash
# tools/pkg-install.sh — PROTOTIPO de instalador (la referencia de mymy).
# USO: pkg-install.sh <paquete.tar.zst>   (corre como root en el sistema)
# Instalación en DOS PASOS: staging → chequeo de conflictos → mover.
# Lecciones de la corrida libxml2 (dogfooding): saltar metadatos al mover,
# DB plana por archivo (no por ruta), stdin de mv por fd 3.
set -euo pipefail

PKG=$1
[ -f "$PKG" ] || { echo "no existe $PKG" >&2; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "requiere root" >&2; exit 1; }

STG=/var/lib/mymy/staging/.install-$$
DB=/var/lib/mymy/db
LOCK=/var/lib/mymy/lock
mkdir -p "$STG" "$DB"

# Bloqueo atómico (PLAN: mkdir)
if ! mkdir "$LOCK" 2>/dev/null; then
    echo "otra instancia de mymy corre (lock activo)" >&2; exit 1
fi
trap 'rm -rf "$STG" "$LOCK"' EXIT

# 1) Verificar integridad del paquete
zstd -t "$PKG"

# 2) Extraer a staging (NUNCA directo a /)
#    Rechazar rutas absolutas o con ..  (validación de seguridad)
tar --zstd -tf "$PKG" | while IFS= read -r f; do
    case "$f" in
        /../*|../*|*/../*|..) echo "RUTA MALICIOSA: $f" >&2; exit 1 ;;
        /*) echo "RUTA ABSOLUTA (no permitida): $f" >&2; exit 1 ;;
    esac
done
tar --zstd -xpf "$PKG" -C "$STG" --numeric-owner --keep-directory-symlink
[ -f "$STG/.FILES" ] || { echo "el paquete no trae .FILES" >&2; exit 1; }

# 3) Chequear conflictos contra la DB de otros paquetes.
#    DB PLANA: /var/lib/mymy/db/<pkg>/FILES — un archivo por paquete.
#    (los metadatos .FILES/.PKGINFO NO cuentan como archivos del sistema)
conflict=0
exec 3< "$STG/.FILES"
while IFS= read -r f <&3; do
    if [ "$f" = ".FILES" ] || [ "$f" = ".PKGINFO.toml" ]; then continue; fi
    if [ -e "/$f" ]; then
        for other in "$DB"/*/; do
            if [ ! -d "$other" ]; then continue; fi
            oname=${other%/}; oname=${oname##*/}
            if grep -qxF "$f" "$other/FILES" 2>/dev/null; then
                echo "CONFLICTO: /$f ya pertenece a $oname" >&2
                conflict=1
            fi
        done
    fi
done
exec 3<&-
if [ $conflict -ne 0 ]; then
    echo "instalación abortada (conflictos)" >&2
    exit 1
fi

# 4) Mover a / y registrar (fd 3: mv consume stdin del while)
exec 3< "$STG/.FILES"
while IFS= read -r f <&3; do
    if [ "$f" = ".FILES" ] || [ "$f" = ".PKGINFO.toml" ]; then continue; fi
    target="/$f"
    mkdir -p "$(dirname "$target")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        # archivo del sistema sin dueño: respaldar como .mymy-orig
        mv "$target" "${target}.mymy-orig"
    fi
    mv "$STG/$f" "$target"
done
exec 3<&-

# registro: lista completa del paquete (los metadatos NO van al sistema;
# el PKGINFO/FILES ya quedaron copiados abajo en la DB)
PKGNAME=$(basename "$PKG" .tar.zst)
mkdir -p "$DB/$PKGNAME"
grep -v -x -e '.FILES' -e '.PKGINFO.toml' "$STG/.FILES" > "$DB/$PKGNAME/FILES" \
    || { echo "FILES vacío tras filtrar" >&2; exit 1; }
if [ -f "$STG/.PKGINFO.toml" ]; then
    cp "$STG/.PKGINFO.toml" "$DB/$PKGNAME/PKGINFO.toml"
fi
rm -rf "$STG"

# hooks post-install (PLAN: triggers)
if [ -x /etc/mymy/hooks/post-install ]; then
    /etc/mymy/hooks/post-install "$PKGNAME" || true
fi
if grep -qE '^usr/lib/' "$DB/$PKGNAME/FILES" 2>/dev/null; then
    ldconfig || true
fi

echo "OK: $PKGNAME instalado"
