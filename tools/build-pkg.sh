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
# LECCIÓN (run 41421897232): con 'set -euo pipefail', un grep SIN match
# devuelve 1 → el pipeline mata el script EN SILENCIO (sin imprimir
# '==> build-pkg'), y el workflow solo ve 'exit code 1'. Por eso get()
# ya no falla: usa awk (que devuelve 0 aunque no encuentre nada) y
# exige() valida los campos obligatorios con un error explícito.
get() { awk -F'=' -v k="$1" '$1 ~ "^[[:space:]]*"k"[[:space:]]*$" {v=$2; gsub(/^[[:space:]]+|[[:space:]]+$/,"",v); gsub(/^"|"$/,"",v); print v; exit}' "$RECIPE_DIR/recipe.toml"; }
require() {
  local v; v=$(get "$1")
  if [ -z "$v" ]; then
    echo "ERROR: la receta $RECIPE_DIR no define '$1' (obligatorio)" >&2
    exit 1
  fi
  printf '%s' "$v"
}
NAME=$(require name)
VERSION=$(require version)
RELEASE=$(require release)
PKG="${NAME}-${VERSION}-${RELEASE}"
DESTDIR_STG="/staging/${PKG}"


echo "==> build-pkg: ${PKG}"

# Staging limpio
rm -rf "$DESTDIR_STG"
mkdir -p "$DESTDIR_STG" "$OUT"

rm -rf /tmp/build
mkdir -p /tmp/build

# TODAS las fuentes del recipe.toml, con prefijo <paquete>__ (evita
# colisiones de tags genéricos). Extraídas al cwd para build.sh.
# export PKG_SRC apunta a la PRIMERA (la del paquete mismo).
ALL_SRCS=$(awk '/^sources *=/{f=1} f{print} f && /\]/{exit}' "$RECIPE_DIR/recipe.toml" | grep -oE 'https?://[^", ]+' || true)
i=0
first=""
for u in $(printf '%s' "$ALL_SRCS" | tr ',' ' ' | tr -d '"'); do
  i=$((i+1))
  tb="${NAME}__$(basename "$u")"
  [ -f "${SRC}/${tb}" ] || { echo "falta fuente $tb en $SRC"; exit 1; }
  if [ $i -eq 1 ]; then first="${SRC}/${tb}"; fi
  # Fuente NO-tarball (fichero plano, p.ej. firmware .bin): `tar -xpf` fallaría
  # con "not in gzip format" y mataría el build. Se copia tal cual.
  if tar -tf "${SRC}/${tb}" >/dev/null 2>&1; then
    tar -xpf "${SRC}/${tb}" -C /tmp/build --keep-directory-symlink
  else
    cp -f "${SRC}/${tb}" "/tmp/build/${tb}"
  fi
done
export PKG_SRC="$first"
if [ -n "$first" ]; then
  # cwd de build.sh = dir raiz del PRIMER tarball (sin pipes: leccion stage4).
  # Fuente PLANA (no tarball, p.ej. .bin de firmware): no hay dir raiz que
  # entrar → el build.sh trabaja en /tmp/build (donde se copiaron).
  if tar -tf "$first" > /tmp/build/.list 2>/dev/null && [ -s /tmp/build/.list ]; then
    PKG_DIR=$(awk -F/ 'NR==1{print $1; exit}' /tmp/build/.list)
    if [ -n "$PKG_DIR" ] && [ -d "/tmp/build/$PKG_DIR" ]; then
      cd "/tmp/build/$PKG_DIR"
    elif ! grep -q '/' /tmp/build/.list; then
      # tarball PLANO: binarios en la raiz sin subdir (cargo-c) → build.sh
      # trabaja en /tmp/build.
      cd /tmp/build
    else
      echo "tarball sin dir raíz: $first"; exit 1
    fi
  else
    cd /tmp/build
  fi
else
  # receta SIN sources (mymy): copiar repo a /tmp/build/mymy-repo
  mkdir -p /tmp/build/mymy-repo
  cp -r /recipes/../mymy /tmp/build/mymy-repo/mymy 2>/dev/null || true
  cp -r /recipes/../keys /tmp/build/mymy-repo/keys 2>/dev/null || true
  [ -f /tmp/build/mymy-repo/mymy/mymy ] || { echo "falta /mymy en la raiz del chroot para receta sin sources"; exit 1; }
  cd /tmp/build
fi
# Ejecutar build.sh de la receta con DESTDIR apuntando al staging.
# OJO: el cd al dir del paquete ya se hizo arriba; NO pisarlo con
# 'cd /tmp/build' (bug de esta saga: build.sh quedaba sin fuentes).
export DESTDIR="$DESTDIR_STG"
export SRC
# rust vive en /opt/rust (build_tool rust); sin esto 'cargo: command not found'.
export PATH="/opt/rust/bin:/usr/bin:/usr/sbin:/bin:$PATH"
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
# .FILES: rutas relativas (excluyendo a .FILES mismo — se crea después)
( cd "$DESTDIR_STG" && find . -type f -o -type l | sed 's|^\./||' | grep -v '^\.FILES$' | sort ) > "$DESTDIR_STG/.FILES"

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
# Instalar TAMBIÉN al chroot real: los paquetes siguientes compilan
# contra este (matriz por capas del PLAN). El staging/tarball queda
# igual; el chroot es efímero del job.
tar --zstd -xpf "${OUT}/${PKG}.tar.zst" -C / --keep-directory-symlink
ldconfig 2>/dev/null || true
sha256sum "${OUT}/${PKG}.tar.zst" | tee "${OUT}/${PKG}.tar.zst.sha256"

echo "==> OK: ${OUT}/${PKG}.tar.zst"
