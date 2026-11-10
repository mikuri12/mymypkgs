#!/bin/bash
# tools/update-upstream.sh [--push] [paquete...]
# Rolling de versiones: para cada receta con campo `upstream`, consulta la
# última release (o tag) del repo upstream y, si es más nueva que la
# versión de la receta, reescribe recipe.toml (version, sources, checksums
# con sha256 real descargando el tarball) y pone release = 1.
# Con --push hace commit+push (dispara el run pkg-<paquete> por paths).
#
# Formatos de upstream:
#   upstream = "github:owner/repo"
#   upstream = "gitlab:host/group/proj"   (API v4 de esa instancia)
set -euo pipefail
cd "$(dirname "$0")/.."

PUSH=0
if [ "${1:-}" = "--push" ]; then PUSH=1; shift; fi

# normaliza un tag a versión: quita v/V inicial; R_2_6_4 -> 2.6.4
norm() {
  printf '%s' "$1" | sed -E 's/^[vV]//; s/^R_//; s/_/./g'
}

newer() { # newer <actual> <nueva> → 0 si nueva > actual
  [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$2" ] && [ "$1" != "$2" ]
}

update_one() {
  local dir=$1 pkg up scheme rest tag url ver cur out
  pkg=$(basename "$dir")
  up=$(awk -F'=' -v k="upstream" '$1 ~ "^[[:space:]]*"k"[[:space:]]*$" {v=$2; gsub(/^[[:space:]]+|[[:space:]]+$/,"",v); gsub(/^"|"$/,"",v); print v; exit}' "$dir/recipe.toml")
  [ -n "$up" ] || { echo "$pkg: sin upstream, skip"; return 0; }
  scheme=${up%%:*}
  rest=${up#*:}

  case "$scheme" in
    github)
      tag=$(gh api "repos/$rest/releases/latest" -q .tag_name 2>/dev/null) || tag=$(gh api "repos/$rest/tags?per_page=1" -q ".[0].name" 2>/dev/null) || tag=""
      cur_src=$(grep -m1 '^sources' "$dir/recipe.toml" | cut -d'"' -f2)
      case "$cur_src" in
        */releases/download/*) url="https://github.com/$rest/releases/download/$tag/$(basename "$cur_src")" ;;
        *) url="https://github.com/$rest/archive/refs/tags/$tag.tar.gz" ;;
      esac
      ;;
    codeberg)
      # API Gitea: /api/v1/repos/{owner}/{repo}/releases/latest
      tag=$(curl -fsSL "https://codeberg.org/api/v1/repos/$rest/releases/latest" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)['tag_name'])" 2>/dev/null) || tag=$(curl -fsSL "https://codeberg.org/api/v1/repos/$rest/tags?limit=1" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)[0]['name'])" 2>/dev/null) || tag=""
      url="https://codeberg.org/$rest/archive/$tag.tar.gz"
      ;;
    gitlab)
      local host=${rest%%/*} path=${rest#*/}
      local enc
      enc=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1],safe=''))" "$path")
      tag=$(curl -fsSL "https://$host/api/v4/projects/$enc/releases/permalink/latest" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)['tag_name'])" 2>/dev/null) || tag=$(curl -fsSL "https://$host/api/v4/projects/$enc/repository/tags?per_page=1" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)[0]['name'])" 2>/dev/null) || tag=""
      url="https://$host/$path/-/archive/$tag/$(basename "$path")-$tag.tar.gz"
      ;;
    *) echo "$pkg: esquema desconocido '$scheme'"; return 0 ;;
  esac
  echo "$tag" | grep -qE "^[A-Za-z0-9._+~-]+$" && [ "$tag" != "null" ] || { echo "$pkg: tag inválido de $up, skip"; return 0; }

  ver=$(norm "$tag"); ver=${ver#"$pkg"-}
  cur=$(awk -F'=' -v k="version" '$1 ~ "^[[:space:]]*"k"[[:space:]]*$" {v=$2; gsub(/^[[:space:]]+|[[:space:]]+$/,"",v); gsub(/^"|"$/,"",v); print v; exit}' "$dir/recipe.toml")
  if ! newer "$cur" "$ver"; then
    echo "$pkg: $cur == último upstream ($tag), sin cambio"
    return 0
  fi

  echo "$pkg: $cur -> $ver (tag $tag)"
  tmp=$(mktemp -d)
  if ! curl -fsSL --retry 3 -o "$tmp/src.tar.gz" "$url"; then echo "$pkg: fallo descargando $url, skip"; return 0; fi
  sha=$(sha256sum "$tmp/src.tar.gz" | cut -d' ' -f1)
  rm -rf "$tmp"

  python3 - "$dir/recipe.toml" "$ver" "$url" "$sha" <<'PYEOF'
import re, sys
path, ver, url, sha = sys.argv[1:5]
src = open(path).read()
src = re.sub(r'(?m)^version\s*=.*$', f'version = "{ver}"', src, count=1)
src = re.sub(r'(?m)^release\s*=.*$', 'release = 1', src, count=1)
src = re.sub(r'(?m)^sources\s*=.*$', f'sources = ["{url}"]', src, count=1)
src = re.sub(r'(?m)^checksums\s*=.*$', f'checksums = ["sha256:{sha}"]', src, count=1)
open(path, 'w').write(src)
PYEOF
  echo "$pkg: receta actualizada a $ver (sha256 $sha)"
}

if [ $# -gt 0 ]; then
  for p in "$@"; do update_one "recipes/$p"; done
else
  for r in recipes/*/; do update_one "$r"; done
fi

if [ $PUSH -eq 1 ]; then
  if git diff --quiet -- recipes; then
    echo "sin cambios que pushar"
  else
    git add recipes
    git commit -m "chore(upstream): bump de versiones desde upstream (rolling)

$(git diff --cached --name-only | sed 's|recipes/||; s|/recipe.toml||' | tr '\n' ' ')"
    git push
    echo "push OK — se disparan los runs pkg-<paquete> de los recetas tocados"
  fi
fi
