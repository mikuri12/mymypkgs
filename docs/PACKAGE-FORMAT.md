# Formato de paquetes mymypkgs (v1)

Cada paquete es un tarball Zstandard:

    <nombre>-<versión>-<release>.tar.zst

con rutas **relativas a `/`** (el tarball se extrae en la raíz al
instalar), propietario `root:root` y permisos conservados
(`--numeric-owner`).

## Contenido

En la raíz de cada tarball van:

- Todos los archivos del paquete (`usr/`, `etc/`, …).
- `.PKGINFO.toml` — metadatos (ver abajo).
- `.FILES` — lista de todos los archivos instalados, una ruta por línea
  (relativa a `/`, sin incluir `.PKGINFO.toml` ni `.FILES`).

## .PKGINFO.toml

```toml
name = "libdrm"
version = "2.4.125"
release = 1
arch = "x86_64-v3"
description = "Userspace library for the Direct Rendering Manager"
depends = []            # paquetes requeridos en runtime (names only)
makedepends = []        # paquetes requeridos SOLO para compilar
config_files = []       # rutas que el gestor protege al actualizar (etc/...)
```

- `arch = "x86_64-v3"` fijo para todo el repo (Skylake, PLAN).
- `depends`/`makedepends` solo aceptan nombres de paquetes de este repo
  (o "base" = presentes en el rootfs de mylfs).

## Recetas

`recipes/<paquete>/recipe.toml` + `recipes/<paquete>/build.sh`:

```toml
# recipe.toml
name = "libdrm"
version = "2.4.125"
release = 1
description = "..."
depends = []
makedepends = []          # p.ej. ["mesa-build-deps"] cuando aplique
sources = [ "https://dri.freedesktop.org/libdrm/libdrm-2.4.125.tar.xz" ]
checksums = [ "sha256:..." ]
config_files = []
```

`build.sh` corre DENTRO del chroot del rootfs (ROOTFS_TAG) con cwd en
el árbol extraído de sources y produce su instalación en
`$DESTDIR` (staging, rutas relativas). El empaquetado lo hace
`tools/build-pkg.sh`.

## Índice

`index.toml` (firmado con ssh-keygen -Y sign):

```toml
[[pkg]]
name = "libdrm"
version = "2.4.125"
release = 1
filename = "libdrm-2.4.125-1.tar.zst"
size = 123456            # bytes del tarball
sha256 = "..."
depends = []
```

La clave pública de verificación vive en `keys/mymy.pub`; mymy la usa
para validar el índice antes de sincronizar.


## Rolling por paquete (v2)

Cada receta tiene su propio run de GitHub Actions (`pkg-<nombre>.yml`,
generado por `tools/gen-pkg-workflows.sh`) que se dispara SOLO al cambiar
`recipes/<nombre>/**`. El run reutilizable `.github/workflows/pkg-build.yml`:

1. restaura el chroot del rootfs (ROOTFS_TAG),
2. instala en el chroot los paquetes ya publicados en el Release rodante
   `packages` (en el orden de `tools/order.txt`) — son las dependencias,
3. compila solo esa receta (`tools/build-pkg.sh`) y la instala,
4. publica el nuevo `.tar.zst` y regenera `index.toml` (publish serializado
   con concurrency group `packages-release-publish`).

El run monolítico `packages.yml` queda solo para cambios de infra
(`tools/**`, `ROOTFS_TAG`, `mymy/**`) y un full rebuild semanal.

## Campos nuevos de recipe.toml

```toml
build_tools = ["cmake", "rust", "libclang"]   # herramientas del chroot para ESTA receta
upstream = "github:owner/repo"                # o "gitlab:host/group/proj", "codeberg:o/r"
```

- `build_tools`: `tools/chroot-prep.sh` instala en el chroot solo lo que la
  receta necesita (cmake 4.1.0 / rust 1.99.1 / libclang 19.1.7 prebuilt).
- `upstream`: el workflow `upstream.yml` (diario 05:00 UTC + manual) corre
  `tools/update-upstream.sh --push`, que consulta la última release/tag del
  upstream y, si es más nueva, reescribe `version`/`sources`/`checksums`
  (sha256 real descargando el tarball) con `release = 1`. El push dispara
  solo el run `pkg-<nombre>` de esa receta → release rodante real con las
  últimas versiones del upstream, sin copiar versiones de void.

## Reglas

- Todo paquete se compila DENTRO del chroot del rootfs indicado por
  `ROOTFS_TAG` (descargado de mylfs Releases), no en el runner.
- DESTDIR/staging siempre; nunca instalar directo en el chroot.
- Strip de binarios/libs al empaquetar; sin docs salvo lo indispensable.
- Tests desactivados (RUN_TESTS=0) salvo receta que los pida.
