#!/bin/bash
# tools/chroot-prep.sh — Prepara el chroot del rootfs con las herramientas
# de build que necesita UNA receta (leídas del campo build_tools de
# recipe.toml). Corre EN EL HOST (usa sudo + chroot); NO dentro del chroot.
# USO: chroot-prep.sh <receta-dir>   (asume /mnt/lfs ya restaurado)
#   build_tools posibles: cmake | rust | libclang   (CA bundle: siempre)
set -euo pipefail

RECIPE_DIR=$1
LFS=/mnt/lfs

get() { awk -F'=' -v k="$1" '$1 ~ "^[[:space:]]*"k"[[:space:]]*$" {v=$2; gsub(/^[[:space:]]+|[[:space:]]+$/,"",v); gsub(/^"|"$/,"",v); gsub(/^\[|\]$/,"",v); gsub(/"/,"",v); gsub(/,/," ",v); print v; exit}' "$RECIPE_DIR/recipe.toml"; }

BT=$(get build_tools)
echo "build_tools de $(basename "$RECIPE_DIR"): ${BT:-<ninguno>}"

sudo mkdir -p "$LFS/sources"

# CA bundle (barato; siempre)
cat > "$LFS/sources/make-cabundle.sh" <<'CABEOF'
set -euo pipefail
mkdir -p /etc/ssl/certs
touch /etc/ssl/certs/ca-certificates.crt
for c in /usr/share/ca-certificates/mozilla/*.crt
do
  [ -e "$c" ] || continue
  cat "$c" >> /etc/ssl/certs/ca-certificates.crt
  h=$(openssl x509 -in "$c" -noout -hash 2>/dev/null || true)
  if [ -n "$h" ]; then
    ln -sf "$c" "/etc/ssl/certs/$h.0"
  fi
done
CABEOF
sudo chroot "$LFS" /usr/bin/env -i HOME=/root TERM="${TERM:-xterm}" \
  PATH=/usr/bin:/usr/sbin LC_ALL=POSIX bash -e /sources/make-cabundle.sh
test -s "$LFS/etc/ssl/certs/ca-certificates.crt" || { echo CA-bundle-vacio; exit 1; }
echo "CA-bundle OK"

case " $BT " in
  *" cmake "*)
    sudo curl -fsSL --retry 3 -o "$LFS/sources/cmake-4.1.0.tar.gz" \
      "https://cmake.org/files/v4.1/cmake-4.1.0.tar.gz"
    echo "80ae27faba5068c8ec12c77bf00e6db3  /mnt/lfs/sources/cmake-4.1.0.tar.gz" | \
      sudo tee "$LFS/sources/cmake.md5" >/dev/null
    sudo bash -c 'cd /mnt/lfs/sources && md5sum -c cmake.md5'
    cat > /tmp/build-cmake.sh << 'CMEOF'
set -euo pipefail
cd /sources
rm -rf cmake-4.1.0
tar -xpf cmake-4.1.0.tar.gz && cd cmake-4.1.0
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake
./bootstrap --prefix=/usr --parallel=$(nproc) \
  -- -DCMAKE_USE_OPENSSL=ON -DBUILD_TESTING=OFF
make -j"$(nproc)"
make install
cd /sources && rm -rf cmake-4.1.0
CMEOF
    sudo cp /tmp/build-cmake.sh "$LFS/sources/build-cmake.sh"
    sudo chroot "$LFS" /usr/bin/env -i HOME=/root TERM="${TERM:-xterm}" \
      PATH=/usr/bin:/usr/sbin LC_ALL=POSIX bash -e /sources/build-cmake.sh
    sudo test -x "$LFS/usr/bin/cmake" || { echo "cmake no instalado"; exit 1; }
    echo "cmake OK en el chroot"
    ;;
esac

case " $BT " in
  *" rust "*)
    RUST_OK=0
    for i in 1 2 3 4 5 6 7 8 9 10; do
      sudo curl -fsSL -o "$LFS/sources/rust.tar.gz" \
        "https://static.rust-lang.org/dist/rust-1.99.1-x86_64-unknown-linux-gnu.tar.gz" \
        && { RUST_OK=1; break; }
      echo "descarga rust falló (intento $i), reintentando en 30s…"
      rm -f "$LFS/sources/rust.tar.gz"
      sleep 30
    done
    [ $RUST_OK -eq 1 ] || { echo "rust.tar.gz inaccesible tras 10 intentos"; exit 1; }
    cat > /tmp/install-rust.sh << 'RSEOF'
set -euo pipefail
cd /sources
rm -rf rust-1.99.1-x86_64-unknown-linux-gnu
tar -xpf rust.tar.gz
cd rust-1.99.1-x86_64-unknown-linux-gnu
./install.sh --prefix=/opt/rust --components=rustc,cargo,rust-std-x86_64-unknown-linux-gnu
cd /sources && rm -rf rust-1.99.1-x86_64-unknown-linux-gnu
RSEOF
    sudo cp /tmp/install-rust.sh "$LFS/sources/install-rust.sh"
    sudo chroot "$LFS" /usr/bin/env -i HOME=/root TERM="${TERM:-xterm}" \
      PATH=/usr/bin:/usr/sbin LC_ALL=POSIX bash -e /sources/install-rust.sh
    sudo test -x "$LFS/opt/rust/bin/cargo" || { echo "cargo no instalado"; exit 1; }
    echo "rust 1.99.1 OK (/opt/rust)"
    ;;
esac

case " $BT " in
  *" libclang "*)
    LLVM_OK=0
    for i in 1 2 3 4 5 6 7 8 9 10; do
      sudo curl -fsSL -o "$LFS/sources/llvm.tar.xz" \
        "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/LLVM-19.1.7-Linux-X64.tar.xz" \
        && { LLVM_OK=1; break; }
      echo "descarga llvm falló (intento $i), reintentando en 30s…"
      rm -f "$LFS/sources/llvm.tar.xz"
      sleep 30
    done
    [ $LLVM_OK -eq 1 ] || { echo "llvm inaccesible tras 10 intentos"; exit 1; }
    cat > /tmp/install-llvm.sh << 'LLEOF'
set -euo pipefail
cd /sources
rm -rf llvm-extract
tar -xJf llvm.tar.xz
mkdir -p /opt/llvm/lib
cp -a LLVM-19.1.7-Linux-X64/lib/libclang.so* /opt/llvm/lib/
cp -a LLVM-19.1.7-Linux-X64/lib/libLLVM*.so* /opt/llvm/lib/ 2>/dev/null || true
mkdir -p /opt/llvm/lib/clang/19
cp -a LLVM-19.1.7-Linux-X64/lib/clang/19/include /opt/llvm/lib/clang/19/
rm -rf LLVM-19.1.7-Linux-X64
LLEOF
    sudo cp /tmp/install-llvm.sh "$LFS/sources/install-llvm.sh"
    sudo chroot "$LFS" /usr/bin/env -i HOME=/root TERM="${TERM:-xterm}" \
      PATH=/usr/bin:/usr/sbin LC_ALL=POSIX bash -e /sources/install-llvm.sh
    sudo test -f "$LFS/opt/llvm/lib/libclang.so.19.1.7" || { echo "libclang no instalada"; exit 1; }
    sudo test -f "$LFS/opt/llvm/lib/clang/19/include/stddef.h" || { echo "resource dir ausente"; exit 1; }
    echo "libclang OK (/opt/llvm/lib + clang/19)"
    ;;
esac
