#!/bin/bash
# greetd 0.10.3 — cargo build (Rust). toolchain prebuilt del runner.
set -euo pipefail
export CARGO_INCREMENTAL=0
cargo build --release
# binarios: greetd y agreety (greeter de prueba; el de Noctalia va luego)
install -v -D -m755 target/release/greetd "$DESTDIR/usr/sbin/greetd"
install -v -D -m755 target/release/agreety "$DESTDIR/usr/bin/agreety"
# config por defecto: agreety (el greeter real de Noctalia va después)
install -v -d "$DESTDIR/etc/greetd" "$DESTDIR/etc/sv/greetd"
printf '%s\n' \
  '[terminal]' \
  'vt = 7' \
  '' \
  '[default_session]' \
  'command = "agreety --cmd bash"' \
  'user = "greeter"' \
  > "$DESTDIR/etc/greetd/config.toml"
chmod 644 "$DESTDIR/etc/greetd/config.toml"
# servicio runit (PLAN: greetd como servicio)
printf '%s\n' '#!/bin/sh' 'exec /usr/sbin/greetd' > "$DESTDIR/etc/sv/greetd/run"
chmod 755 "$DESTDIR/etc/sv/greetd/run"
