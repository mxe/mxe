# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# PostgreSQL
PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.4.2
$(PKG)_CHECKSUM := a617698ef3b41a74fe2c4af346172eb03e7f8a7f
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.postgresql.org/
$(PKG)_URL      := http://ftp2.nl.postgresql.org/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp10.us.postgresql.org/postgresql/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib openssl

define $(PKG)_UPDATE
    wget -q -O- 'http://anoncvs.postgresql.org/cvsweb.cgi/pgsql/' | \
    grep '<option>REL' | \
    $(SED) -n 's,.*REL\([0-9][0-9_]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    # The static OpenSSL libraries are in unix (not win32) naming style.
    $(SED) 's,SSLEAY32,SSL,' -i '$(1)'/configure
    $(SED) 's,ssleay32,ssl,' -i '$(1)'/configure
    $(SED) 's,EAY32,CRYPTO,' -i '$(1)'/configure
    $(SED) 's,eay32,crypto,' -i '$(1)'/configure
    $(SED) 's,ssleay32,ssl,' -i '$(1)'/src/interfaces/libpq/Makefile
    $(SED) 's,eay32,crypto,' -i '$(1)'/src/interfaces/libpq/Makefile
    # Since we build only client libary, use bogus tzdata to satisfy configure.
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --with-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --with-zlib \
        --with-system-tzdata=/dev/null \
        LIBS='-lsecur32 -lws2_32 -lgdi32'
    $(MAKE) -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' install haslibarule= shlib=
    $(MAKE) -C '$(1)'/src/port             -j '$(JOBS)'         haslibarule= shlib=
    $(MAKE) -C '$(1)'/src/bin/psql         -j '$(JOBS)' install haslibarule= shlib=
    $(INSTALL) -m664 '$(1)/src/include/pg_config.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m664 '$(1)/src/include/postgres_ext.h' '$(PREFIX)/$(TARGET)/include/'
endef
