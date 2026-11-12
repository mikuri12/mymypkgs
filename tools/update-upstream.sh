#!/bin/bash
# tools/update-upstream.sh [--push] [paquete...]
# Rolling desde upstream con guards anti-3ffcb1f: solo tags version-like (sin
# beta/rc/pre); la fuente nunca pasa a archive/ salvo que ya lo sea; se
# conserva host/patron (sustituye tag/version/maj.min) y se verifica descarga.
set -euo pipefail
cd "$(dirname "$0")/.."
PUSH=0
[ "${1:-}" = "--push" ] && { PUSH=1; shift; }
vlike() { printf "%s" "$1" | grep -qE "^[vV]?[0-9]+([._-][0-9A-Za-z]+)*$" && ! printf "%s" "$1" | grep -qiE "beta|alpha|rc[._-]?[0-9]|pre[._-]?[0-9]|dev|snapshot"; }
tover() { local t=$1 p=$2 q ql tl; case "$t" in [vV][0-9]*) t=${t:1} ;; esac; t=$(printf "%s" "$t" | sed -E "s/^[rR][eE][lL][._-]?//; s/^R_//; s/_/./g"); for q in "$p" "${p#lib}"; do [ -n "$q" ] || continue; ql=$(printf "%s" "$q" | tr "[:upper:]" "[:lower:]"); tl=$(printf "%s" "$t" | tr "[:upper:]" "[:lower:]"); [ "${tl#"$ql"}" != "$tl" ] && { t=${t:${#q}}; t=${t#[-._]}; break; }; done; vlike "$t" || t=""; printf "%s" "$t"; }
newer() { [ "$(printf "%s\n%s\n" "$1" "$2" | sort -V | tail -1)" = "$2" ] && [ "$1" != "$2" ]; }
ftags() { while IFS= read -r t; do vlike "$t" && printf "%s\n" "$t"; done | sort -V | tail -1; }
getf() { sed -n "s/^$1 *= *\"\(.*\)\".*/\1/p" "$2"; }
san() { local x=$1; printf "%s" "$x" | grep -qE "^[A-Za-z0-9._+~-]+$" && printf "%s" "$x" || true; }
oktag() { [ -n "$(san "$1")" ]; }
pick() { local s=$1 r=$2 t=""; case "$s" in
github) t=$(san "$(gh api "repos/$r/releases/latest" -q .tag_name 2>/dev/null || true)"); oktag "$t" || t=$(gh api "repos/$r/tags?per_page=100" -q ".[].name" 2>/dev/null | ftags) ;;
gitlab) local h=${r%%/*} p=${r#*/} e; e=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1],safe=\"\"))" "$p"); t=$(curl -fsSL --max-time 30 "https://$h/api/v4/projects/$e/releases/permalink/latest" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)[\"tag_name\"])" 2>/dev/null || true); oktag "$t" || t=$(curl -fsSL --max-time 30 "https://$h/api/v4/projects/$e/repository/tags?per_page=100" 2>/dev/null | python3 -c "import json,sys; [print(x[\"name\"]) for x in json.load(sys.stdin)]" 2>/dev/null | ftags) ;;
codeberg) t=$(curl -fsSL --max-time 30 "https://codeberg.org/api/v1/repos/$r/releases/latest" 2>/dev/null | python3 -c "import json,sys; print(json.load(sys.stdin)[\"tag_name\"])" 2>/dev/null || true); oktag "$t" || t=$(curl -fsSL --max-time 30 "https://codeberg.org/api/v1/repos/$r/tags?limit=100" 2>/dev/null | python3 -c "import json,sys; [print(x[\"name\"]) for x in json.load(sys.stdin)]" 2>/dev/null | ftags) ;;
esac; san "$t"; }
okurl() { curl -fsSI -L --max-time 30 "$1" >/dev/null 2>&1 && return 0; curl -fsSL --max-time 30 -r 0-0 -o /dev/null "$1" 2>/dev/null; }
upd() { local d=$1 pkg up s r tag cs cur nv nt oldt omaj nmaj url sha tmp base c seen; pkg=$(basename "$d"); if [ -f tools/upstream-skip.txt ] && grep -qx "$pkg" tools/upstream-skip.txt; then echo "$pkg: skip (upstream-skip.txt)"; return 0; fi; up=$(getf upstream "$d/recipe.toml"); [ -n "$up" ] || { echo "$pkg: sin upstream, skip"; return 0; }; s=${up%%:*}; r=${up#*:}; tag=$(pick "$s" "$r"); oktag "$tag" || { echo "$pkg: tag invalido, skip"; return 0; }; vlike "$tag" || { echo "$pkg: tag $tag no version-like, skip"; return 0; }; cs=$(grep -A3 -m1 "^sources" "$d/recipe.toml" | grep -oE "https?://[^\" ,]+" | sed -n "1p"); cur=$(getf version "$d/recipe.toml"); nt=$tag; nv=$(tover "$tag" "$pkg"); [ -n "$nv" ] || { echo "$pkg: tag $tag sin version valida, skip"; return 0; }; newer "$cur" "$nv" || { echo "$pkg: $cur == upstream ($tag), sin cambio"; return 0; }
  oldt=$(printf "%s" "$cs" | grep -oE "R_[0-9_]+|[rR][eE][lL][._-]?[0-9][0-9_.]*|[vV]?[0-9]+[0-9A-Za-z._+-]*" | tail -1); omaj=$(printf "%s" "$cur" | cut -d. -f1-2); nmaj=$(printf "%s" "$nv" | cut -d. -f1-2); base=$(printf "%s" "$cs" | sed -e "s|$cur|$nv|g" -e "s|/$omaj/|/$nmaj/|g"); local -a cand=(); cand+=("$(printf "%s" "$base" | sed "s|$oldt|$nt|g")"); for c in "${cand[@]}"; do case "$c" in *.tar.gz) cand+=("${c%.tar.gz}.tar.xz" "${c%.tar.gz}.tar.bz2") ;; *.tar.xz) cand+=("${c%.tar.xz}.tar.gz" "${c%.tar.xz}.tar.bz2") ;; *.tar.bz2) cand+=("${c%.tar.bz2}.tar.gz" "${c%.tar.bz2}.tar.xz") ;; esac; done
  case "$cs" in *github.com*/archive/refs/tags/*) cand+=("https://github.com/$r/archive/refs/tags/$nt.tar.gz") ;; */-/archive/*) cand+=("https://${r%%/*}/${r#*/}/-/archive/$nt/$(basename "${r#*/}")-$nt.tar.gz") ;; *codeberg.org/*/archive/*) cand+=("https://codeberg.org/$r/archive/$nt.tar.gz") ;; esac; case "$cs" in *github.com*/releases/download/*) cand+=("https://github.com/$r/releases/download/$nt/$(basename "$cs" | sed "s|$cur|$nv|g")") ;; esac
  url=""; seen=""; for c in "${cand[@]}"; do [ -n "$c" ] || continue; case "$seen" in *"|$c|"*) continue ;; esac; seen="$seen|$c|"; [ "$c" != "$cs" ] && okurl "$c" && { url=$c; break; }; done; [ -n "$url" ] || { echo "$pkg: ninguna URL sirve para $tag, skip (receta intacta)"; return 0; }; echo "$pkg: $cur -> $nv (tag $tag) $url"; tmp=$(mktemp -d); curl -fsSL --retry 3 --max-time 300 -o "$tmp/src" "$url" || { echo "$pkg: fallo descarga, skip"; return 0; }; sha=$(sha256sum "$tmp/src" | cut -d" " -f1); python3 - "$d/recipe.toml" "$nv" "$url" "$sha" <<"PYEOF"
import re, sys
path, ver, url, sha = sys.argv[1:5]
src = open(path).read()
src = re.sub("(?m)^version\\s*=.*$", "version = \"" + ver + "\"", src, count=1)
src = re.sub("(?m)^release\\s*=.*$", "release = 1", src, count=1)
src = re.sub("(?s)^sources\\s*=\\s*\\[.*?\\]", "sources = [\"" + url + "\"]", src, count=1, flags=re.M)
src = re.sub("(?s)^checksums\\s*=\\s*\\[.*?\\]", "checksums = [\"sha256:" + sha + "\"]", src, count=1, flags=re.M)
open(path, "w").write(src)
PYEOF
  echo "$pkg: receta -> $nv (sha256 $sha)"; }
if [ $# -gt 0 ]; then for p in "$@"; do upd "recipes/$p"; done; else for r in recipes/*/; do upd "$r"; done; fi
if [ $PUSH -eq 1 ]; then if git diff --quiet -- recipes; then echo "sin cambios que pushar"; else git add recipes; git commit -m "chore(upstream): bump de versiones desde upstream (rolling)"; git push; echo "push OK"; fi; fi
