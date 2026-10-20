#!/bin/bash
# tools/make-index.sh — Genera index.toml desde los paquetes de un dir.
# USO: make-index.sh <packages-dir> > index.toml
set -euo pipefail

DIR=$1
[ -d "$DIR" ] || { echo "no existe $DIR"; exit 1; }

echo "# index.toml — generado $(date -u +%Y-%m-%dT%H:%M:%SZ) por make-index.sh"
echo "# Firmar con: ssh-keygen -Y sign -f <clave> -n mymy index.toml"

for pkg in "$DIR"/*.tar.zst; do
    name=$(basename "$pkg" .tar.zst)
    # <name>-<version>-<release>
    release=${name##*-}
    nov=${name%-${release}}
    version=${nov##*-}
    pname=${nov%-${version}}
    sha=$(sha256sum "$pkg" | cut -d' ' -f1)
    size=$(stat -c%s "$pkg")
    # .PKGINFO.toml del tarball para depends
    deps=$(tar --zstd -xOf "$pkg" .PKGINFO.toml 2>/dev/null | grep -E '^depends' | sed -E 's/^[^=]+= *\[(.*)\]$/\1/' || echo "")
    {
        echo "[[pkg]]"
        echo "name = \"$pname\""
        echo "version = \"$version\""
        echo "release = $release"
        echo "filename = \"$(basename "$pkg")\""
        echo "size = $size"
        echo "sha256 = \"$sha\""
        echo "depends = [$deps]"
        echo ""
    }
done
