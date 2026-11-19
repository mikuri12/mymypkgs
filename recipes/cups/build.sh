#!/bin/bash
# cups 2.4.20 — autotools (el -source.tar.gz trae configure generado).
# Opciones verificadas contra ./configure --help del tarball:
#   --with-ondemand=no  (acepta no/yes/launchd/systemd/upstart; sin el, en Linux cae a "yes")
#   --with-tls=openssl, --with-dnssd=avahi (avahi ya publicado)
#   sin --with-systemd ni --with-rcdir -> no instala unidades ni rc scripts
set -euo pipefail
cd /tmp/build/cups-*
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  --with-rundir=/run \
  --with-ondemand=no \
  --with-tls=openssl \
  --with-dnssd=avahi \
  --with-cups-user=lp --with-cups-group=lp \
  --with-docdir=/usr/share/doc/cups
make -j"$(nproc)"
make DESTDIR="$DESTDIR" install
# Servicio runit del sistema (sin systemd).
install -d "$DESTDIR/etc/sv/cupsd"
printf '%s\n' '#!/bin/sh' 'exec /usr/sbin/cupsd -f' > "$DESTDIR/etc/sv/cupsd/run"
chmod 755 "$DESTDIR/etc/sv/cupsd/run"
# Hook post-install de mymy: usuario/grupo lp y dirs de estado.
install -d "$DESTDIR/etc/mymy/hooks/post-install"
cat > "$DESTDIR/etc/mymy/hooks/post-install/cups" <<'HEOF'
#!/bin/sh
getent group lp >/dev/null 2>&1 || groupadd -r lp
getent passwd lp >/dev/null 2>&1 || useradd -r -g lp -d /var/spool/cups -s /usr/sbin/nologin -c "printing" lp
mkdir -p /run/cups /var/spool/cups /var/log/cups /var/cache/cups
chown lp:lp /var/spool/cups /var/log/cups /var/cache/cups 2>/dev/null || true
HEOF
chmod 755 "$DESTDIR/etc/mymy/hooks/post-install/cups"
