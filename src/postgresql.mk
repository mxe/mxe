# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# PostgreSQL
PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.0.0
$(PKG)_CHECKSUM := ed2f83cd1a83c40dcbe0ba19ee3ba2a7faa0de3d
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
    $(SED) -i 's,SSLEAY32,SSL,' '$(1)'/configure
    $(SED) -i 's,ssleay32,ssl,' '$(1)'/configure
    $(SED) -i 's,EAY32,CRYPTO,' '$(1)'/configure
    $(SED) -i 's,eay32,crypto,' '$(1)'/configure
    $(SED) -i 's,ssleay32,ssl,' '$(1)'/src/interfaces/libpq/Makefile
    $(SED) -i 's,eay32,crypto,' '$(1)'/src/interfaces/libpq/Makefile
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
    # Build a native pg_config.
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,postgresql)
    mv '$(1)/$(postgresql_SUBDIR)' '$(1).native'
    $(SED) -i 's,-DVAL_,-D_DISABLED_VAL_,g' '$(1).native'/src/bin/pg_config/Makefile
    cd '$(1).native' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
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
        --without-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --without-zlib \
        --with-system-tzdata=/dev/null
    $(MAKE) -C '$(1).native'/src/port          -j '$(JOBS)'
    $(MAKE) -C '$(1).native'/src/bin/pg_config -j '$(JOBS)'
    $(INSTALL) -m755 '$(1).native'/src/bin/pg_config/pg_config '$(PREFIX)/bin/$(TARGET)-pg_config'
endef
