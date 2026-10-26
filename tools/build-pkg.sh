#!/bin/bash
# tools/build-pkg.sh — Construye un paquete mymypkgs desde una receta.
# USO: build-pkg.sh <receta-dir> <sources-cache> <out-dir>
#   Corre DENTRO del chroot del rootfs (ya con las fuentes en /sources).
#   El chroot lo prepara el workflow; aquí solo se compila y empaqueta.
set -euo pipefail

RECIPE_DIR=$1        # /recipes/<pkg>
SRC=$2               # /sources (cache de tarballs verificada)
OUT=$3               # /packages (salida)

# Cargar receta (toml minimal: claves planas)
# get soporta valores con comillas Y numéricos (release = 1)
get() { grep -E "^${1} *=" "$RECIPE_DIR/recipe.toml" | head -1 | sed -E 's/^[^=]+= *//; s/^"(.*)"$/\1/'; }
NAME=$(get name)
VERSION=$(get version)
RELEASE=$(get release)
PKG="${NAME}-${VERSION}-${RELEASE}"
DESTDIR_STG="/staging/${PKG}"

# Extraer TODAS las fuentes listadas (por ahora 1 por receta, robusto a N)
# El workflow guarda la fuente con prefijo <paquete>__ para evitar colisiones
# de tags genéricos (p.ej. '0.10.3.tar.gz' compartido entre proyectos).
FIRST_SRC=$(grep -E '^sources' "$RECIPE_DIR/recipe.toml" | sed -E 's/^[^=]+= *\[ *"([^"]+)".*$/\1/')
TARBALL="${NAME}__$(basename "$FIRST_SRC")"
[ -f "${SRC}/${TARBALL}" ] || { echo "falta fuente $TARBALL en $SRC"; exit 1; }

echo "==> build-pkg: ${PKG}"

# Staging limpio
rm -rf "$DESTDIR_STG"
mkdir -p "$DESTDIR_STG" "$OUT"

rm -rf /tmp/build
mkdir -p /tmp/build
tar -xpf "${SRC}/${TARBALL}" -C /tmp/build --strip-components=1

# Ejecutar build.sh de la receta con DESTDIR apuntando al staging
export DESTDIR="$DESTDIR_STG"
export SRC
cd /tmp/build
bash "$RECIPE_DIR/build.sh"

# Verificar que produjo algo
[ -n "$(find "$DESTDIR_STG" -type f 2>/dev/null)" ] || { echo "staging vacío tras build.sh"; exit 1; }

# Normalizar: root:root, sin .keep, strip de binarios
# (strip solo ELF; scripts los salta — lección de stage3)
find "$DESTDIR_STG" -exec touch -d '@0' {} \; 2>/dev/null || true
for i in $(find "$DESTDIR_STG" -type f); do
    case "$i" in
        *.py|*.sh|*.pl|*.conf|*.awk|*.pm|*.toml) continue ;;
    esac
    strip --strip-unneeded "$i" 2>/dev/null || true
done

# .FILES: rutas relativas a la raíz del staging
( cd "$DESTDIR_STG" && find . -type f -o -type l | sed 's|^\./||' | sort ) > "$DESTDIR_STG/.FILES"

# .PKGINFO.toml
{
  printf 'name = "%s"\n' "$NAME"
  printf 'version = "%s"\n' "$VERSION"
  printf 'release = %s\n' "$RELEASE"
  printf 'arch = "x86_64-v3"\n'
  printf 'description = "%s"\n' "$(get description)"
  printf 'depends = [%s]\n' "$(grep -E '^depends' "$RECIPE_DIR/recipe.toml" | head -1 | sed -E 's/^[^=]+= *\[(.*)\]$/\1/')"
  printf 'makedepends = [%s]\n' "$(grep -E '^makedepends' "$RECIPE_DIR/recipe.toml" | head -1 | sed -E 's/^[^=]+= *\[(.*)\]$/\1/')"
  printf 'config_files = [%s]\n' "$(grep -E '^config_files' "$RECIPE_DIR/recipe.toml" | head -1 | sed -E 's/^[^=]+= *\[(.*)\]$/\1/')"
} > "$DESTDIR_STG/.PKGINFO.toml"

# Empaquetar: rutas relativas a /, root:root, permisos conservados
tar --zstd -cpf "${OUT}/${PKG}.tar.zst" -C "$DESTDIR_STG" . \
    --numeric-owner --keep-directory-symlink --sort=name
zstd -t "${OUT}/${PKG}.tar.zst"
sha256sum "${OUT}/${PKG}.tar.zst" | tee "${OUT}/${PKG}.tar.zst.sha256"

echo "==> OK: ${OUT}/${PKG}.tar.zst"
