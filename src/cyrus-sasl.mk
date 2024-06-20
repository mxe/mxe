# This file is part of MXE.
# See index.html for further information.

PKG             := cyrus-sasl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.28
$(PKG)_CHECKSUM := 7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz
$(PKG)_URL      := https://github.com/cyrusimap/$(PKG)/releases/download/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cyrusimap.org/' | \
    $(SED) -n "s,.*cyrus-sasl-\\([0-9][^']*\\)\.tar\.gz.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cp '$(PWD)/src/cyrus-sasl-md5global.h' \
        '$(1)/include/md5global.h'

    cd '$(1)' && \
        LIBS="`'$(TARGET)-pkg-config' --libs openssl`" \
        ./configure \
            $(MXE_CONFIGURE_OPTS) \
            --disable-sample \
            --with-openssl='$(PREFIX)/$(TARGET)' \
            --enable-ntlm \
            --enable-login \
            RANLIB='$(TARGET)-ranlib'
    # -j1: errors with ln -s getnameinfo.lo getnameinfo.o
	$(MAKE) CPPFLAGS="-D_WIN32" -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install
endef
