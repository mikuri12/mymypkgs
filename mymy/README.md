# mymy — gestor de paquetes de mymypkgs

Shell POSIX puro (#!/bin/sh, sin bashismos; shellcheck -s sh + dash en CI).

Comandos: sync, install, remove, upgrade, search, list, info, files,
owns, verify.

Se implementa en la fase 2 (tras validar el flujo de la receta libdrm).
tools/pkg-install.sh es el prototipo de referencia del install.
