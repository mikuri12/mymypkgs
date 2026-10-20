# mymypkgs

Paquetes nativos **x86_64-v3** (Skylake) para [mylfs](https://github.com/mikuri12/mylfs),
construidos en GitHub Actions **dentro del chroot** del rootfs que indica `ROOTFS_TAG`.

## Estructura

- `recipes/<paquete>/` — `recipe.toml` (metadatos, fuentes, checksums) + `build.sh`
- `tools/` — `build-pkg.sh` (compila y empaqueta), `make-index.sh` (genera index.toml),
  `pkg-install.sh` (prototipo de instalador en 2 pasos con staging)
- `keys/mymy.pub` — clave pública para verificar la firma del índice
- `ROOTFS_TAG` — tag del rootfs de mylfs contra el que se compila
- `docs/PACKAGE-FORMAT.md` — especificación del formato `<name>-<version>-<release>.tar.zst`
- `mymy/` — el gestor de paquetes (shell POSIX) — se desarrolla en la fase 2

## Releases

Todo se publica en el **Release rodante `packages`** de este repo:
primero los `.tar.zst` + `.sha256`, y **al final** `index.toml` (+ `index.toml.sig`,
firmado con `ssh-keygen -Y sign`; verificar con `keys/mymy.pub`).

## Verificación manual

```sh
# índice
ssh-keygen -Y verify -f keys/mymy.pub -I mymy -n mymy -s index.toml.sig < index.toml
# paquete
sha256sum -c libdrm-2.4.125-1.tar.zst.sha256
```
