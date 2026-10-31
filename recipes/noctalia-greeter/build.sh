#!/bin/bash
# noctalia-greeter 1.7.0 — meson (C++20 greeter + C compositor wlroots 0.20).
# Instala binarios + scripts de setup; la config de greetd/PAM va en
# post-install (usuario greeter, /var/lib/noctalia-greeter, config.toml).
set -euo pipefail
mkdir build && cd build
meson setup --prefix=/usr --buildtype=release \
  -D tests=false \
  ..
ninja
DESTDIR="$DESTDIR" ninja install

# scripts de setup del sistema (del repo, NO de src/packaging)
SRC=$(ls -d /tmp/build/noctalia-greeter-*/ | head -1)
install -v -d "$DESTDIR/usr/share/noctalia-greeter"
install -v -m755 "$SRC/scripts/"*.sh "$DESTDIR/usr/share/noctalia-greeter/" 2>/dev/null || true
install -v -m755 "$SRC/scripts/noctalia-greeter-session" "$DESTDIR/usr/bin/" 2>/dev/null || true
install -v -m755 "$SRC/scripts/noctalia-greeter-print-greetd-config" "$DESTDIR/usr/bin/" 2>/dev/null || true

# /etc/greetd/config.toml con noctalia-greeter-session y usuario greeter
install -v -d "$DESTDIR/etc/greetd"
printf '%s\n' \
  '[terminal]' \
  'vt = 1' \
  '' \
  '[default_session]' \
  'command = "/usr/bin/noctalia-greeter-session"' \
  'user = "greeter"' \
  > "$DESTDIR/etc/greetd/config.toml"
chmod 644 "$DESTDIR/etc/greetd/config.toml"

# PAM de greetd (basado en setup_greetd_pam.sh del repo)
install -v -d "$DESTDIR/etc/pam.d"
printf '%s\n' \
  'auth     required  pam_securetty.so' \
  'auth     requisite pam_nologin.so' \
  'auth     include   login' \
  'account  include   login' \
  'password include   login' \
  'session  optional  pam_loginuid.so' \
  'session  include   login' \
  > "$DESTDIR/etc/pam.d/greetd"
chmod 644 "$DESTDIR/etc/pam.d/greetd"

# servicio runit de greetd (reemplaza al de la receta greetd base)
install -v -d "$DESTDIR/etc/sv/greetd"
printf '%s\n' '#!/bin/sh' 'exec /usr/sbin/greetd' > "$DESTDIR/etc/sv/greetd/run"
chmod 755 "$DESTDIR/etc/sv/greetd/run"
