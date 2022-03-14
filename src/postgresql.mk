# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := postgresql
$(PKG)_WEBSITE  := https://www.postgresql.org/
$(PKG)_DESCR    := PostgreSQL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 13.6
$(PKG)_CHECKSUM := bafc7fa3d9d4da8fe71b84c63ba8bdfe8092935c30c0aa85c24b2c08508f67fc
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.postgresql.org/pub/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl pthreads zlib pkgconf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.postgresql.org/gitweb?p=postgresql.git;a=tags' | \
    grep 'refs/tags/REL_13[0-9_]*"' | \
    $(SED) 's,.*refs/tags/REL_\(.*\)".*,\1,g;' | \
    $(SED) 's,_,.,g' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cp -Rp '$(1)' '$(1).native'
    # Since we build only client library, use bogus tzdata to satisfy configure.
    # pthreads is needed in both LIBS and PTHREAD_LIBS
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
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
        CFLAGS="-DSSL_library_init=OPENSSL_init_ssl" \
        LIBS="-lsecur32 `'$(TARGET)-pkg-config' openssl pthreads --libs`" \
        ac_cv_func_getaddrinfo=no

    # enable_thread_safety means "build internal pthreads" on windows
    # disable it and link mingw-w64 pthreads to and avoid name conflicts
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' \
        install \
        enable_thread_safety=no \
        PTHREAD_LIBS="`'$(TARGET)-pkg-config' pthreads --libs`"
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1)'/src/port     -j '$(JOBS)' install
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1)'/src/common   -j '$(JOBS)' install
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1)'/src/bin/psql -j '$(JOBS)' install
    $(INSTALL) -m644 '$(1)/src/include/pg_config.h'    '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/src/include/pg_config_ext.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/src/include/postgres_ext.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d    '$(PREFIX)/$(TARGET)/include/libpq'
    $(INSTALL) -m644 '$(1)'/src/include/libpq/*        '$(PREFIX)/$(TARGET)/include/libpq/'
    # Build a native pg_config.
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
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1).native'/src/port          -j '1'
    MXE_BUILD_SHARED=$(BUILD_SHARED) $(MAKE) MAKELEVEL=0 -C '$(1).native'/src/bin/pg_config -j '1' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/pg_config' '$(PREFIX)/bin/$(TARGET)-pg_config'
endef

