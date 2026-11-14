#!/bin/bash
# linux-firmware-i915 — SOLO los 3 blobs que pide el i915.ko de tu kernel
# (v7.1.5-mikuri) para Skylake/HD 530. Nombres extraídos con `strings` del
# propio módulo del release:
#   i915/skl_dmc_ver1_27.bin   (DMC: microcódigo de la GPU, obligatorio)
#   i915/skl_guc_70.1.1.bin    (GuC: firmware de la GPU)
#   i915/skl_huc_2.0.0.bin     (HuC: firma de entorno)
# Fuentes: espejo oficial kernelorg-mirror/linux_kernel_git_firmware_linux-firmware
# (raw.githubusercontent). OJO: git.kernel.org y gitlab.freedesktop.org devuelven
# HTML anti-bot con HTTP 200 (tamaño ~7KB, magic 3c21646f='<!do') — NO usar.
# Sizes reales: 8928 / 206208 / 136320 bytes (validado que NO son HTML).
#
# build-pkg.sh extrae cada source con `tar -xpf` → los .bin NO son tarballs y
# fallarían. Por eso este build.sh los deja en /tmp/build (los .bin arrives
# como <pkg>__<nombre>.bin) y NO usa tar. OJO: build-pkg.sh hace `tar -xpf`
# de CADA source antes de invocar build.sh → para .bin sin tar, ese paso
# falla con "not in gzip format". Workaround: el source se declara como
# .tar.gz (el workflow lo descarga igual) y aquí se EXTRAE con el tar real
# antes de que build-pkg.sh lo intente... no: build-pkg.sh extrae antes.
# → Solución robusta: declarar sources como ficheros .bin y hacer que el
#   propio build.sh los localice por nombre en /tmp/build.
set -euo pipefail
install -v -d "$DESTDIR/usr/lib/firmware/i915"
for f in skl_dmc_ver1_27.bin skl_guc_70.1.1.bin skl_huc_2.0.0.bin; do
  src=$(find /tmp/build -maxdepth 2 -name "*__$f" -type f | head -1)
  [ -n "$src" ] || { echo "falta el blob $f en /tmp/build"; exit 1; }
  install -v -m 0644 "$src" "$DESTDIR/usr/lib/firmware/i915/$f"
done
# El kernel pide también el .bin de debug (no requerido) — no se instala.
ls -l "$DESTDIR/usr/lib/firmware/i915/"
