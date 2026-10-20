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

## Reglas

- Todo paquete se compila DENTRO del chroot del rootfs indicado por
  `ROOTFS_TAG` (descargado de mylfs Releases), no en el runner.
- DESTDIR/staging siempre; nunca instalar directo en el chroot.
- Strip de binarios/libs al empaquetar; sin docs salvo lo indispensable.
- Tests desactivados (RUN_TESTS=0) salvo receta que los pida.
