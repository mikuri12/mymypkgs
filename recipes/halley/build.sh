#!/bin/bash
# halley v0.8.0-mikuri.20 — workspace cargo en la RAÍZ del tarball
# (vendor/smithay parcheado vía [patch] del workspace; NO hay src/crates).
# Referencia exacta: void/template del propio repo (build_style=cargo,
# cargo build --release --workspace --locked, sin --target).
#
# PLAN Fase 2 paso 5: probar LTO fat + codegen-units=1 + strip=symbols.
# Runtime: xwayland-satellite (paquete aparte).
#
# Chroot SIN red: el workflow inyecta el vendor de crates.io en
# /sources/halley-vendor + /root/.cargo/config.toml (source replacement).
set -euo pipefail
export CARGO_INCREMENTAL=0
export CARGO_NET_OFFLINE=true
export CARGO_PROFILE_RELEASE_LTO=fat
export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
export CARGO_PROFILE_RELEASE_STRIP=symbols

# el tarball de GitHub se extrae como halley-0.8.0-mikuri.20/
cd /tmp/build/halley-0.8.0-mikuri.20

cargo build --release --workspace --locked --offline

# binarios (igual que void/template do_install)
install -v -D -m755 target/release/halley                 "$DESTDIR/usr/bin/halley"
install -v -D -m755 target/release/halleyctl              "$DESTDIR/usr/bin/halleyctl"
install -v -D -m755 target/release/halley-lift            "$DESTDIR/usr/bin/halley-lift"
install -v -D -m755 target/release/xdg-desktop-portal-halley "$DESTDIR/usr/bin/xdg-desktop-portal-halley"

# wrapper de sesión (void/halley-session, NO src/packaging) — guard dbus-run-session
install -v -D -m755 void/halley-session "$DESTDIR/usr/bin/halley-session"

# .desktop de sesión para el greeter (usar void/halley.desktop)
install -v -d "$DESTDIR/usr/share/wayland-sessions"
install -v -m644 void/halley.desktop "$DESTDIR/usr/share/wayland-sessions/halley.desktop"

# portal: archivos de void/ (NO src/packaging)
install -v -d "$DESTDIR/usr/share/xdg-desktop-portal/portals"
install -v -m644 void/halley.portal "$DESTDIR/usr/share/xdg-desktop-portal/portals/halley.portal"
install -v -m644 void/halley-portals.conf "$DESTDIR/usr/share/xdg-desktop-portal/halley-portals.conf"
install -v -d "$DESTDIR/usr/share/dbus-1/services"
install -v -m644 packaging/dbus-1/services/org.freedesktop.impl.portal.desktop.halley.service \
  "$DESTDIR/usr/share/dbus-1/services/"

# config por defecto del usuario (halley.rune.0.8-mikuri del repo raíz)
install -v -d "$DESTDIR/etc/halley"
install -v -m644 halley.rune.0.8-mikuri "$DESTDIR/etc/halley/halley.rune"

# servicio runit (estilo /etc/sv/<name>/run)
install -v -d "$DESTDIR/etc/sv/halley"
printf '%s\n' '#!/bin/sh' 'exec /usr/bin/halley-session' > "$DESTDIR/etc/sv/halley/run"
chmod 755 "$DESTDIR/etc/sv/halley/run"
