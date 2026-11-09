#!/bin/bash
# tools/gen-pkg-workflows.sh — Genera .github/workflows/pkg-<nombre>.yml
# para CADA receta de recipes/. Cada workflow corre SOLO ese paquete
# (rolling release por paquete): se dispara al tocar recipes/<nombre>/**
# o su propio workflow, y llama al reutilizable pkg-build.yml.
# USO: tools/gen-pkg-workflows.sh   (escribe en .github/workflows/)
set -euo pipefail
cd "$(dirname "$0")/.."

WF=.github/workflows
mkdir -p "$WF"

gen_one() {
  local pkg=$1
  cat > "$WF/pkg-$pkg.yml" <<EOF
# AUTOGENERADO por tools/gen-pkg-workflows.sh — no editar a mano.
# Runrolling del paquete '$pkg': build individual + publicación al
# Release rodante 'packages'. Se dispara solo al cambiar su receta.
name: pkg-$pkg

on:
  push:
    branches: [main]
    paths:
      - 'recipes/$pkg/**'
      - '$WF/pkg-$pkg.yml'
  workflow_dispatch:

permissions:
  contents: write

concurrency:
  group: pkg-$pkg
  cancel-in-progress: true

jobs:
  build:
    uses: ./$WF/pkg-build.yml
    with:
      package: $pkg
EOF
}

n=0
for r in recipes/*/; do
  pkg=$(basename "$r")
  gen_one "$pkg"
  n=$((n+1))
done
echo "generados $n workflows pkg-*.yml en $WF/"
