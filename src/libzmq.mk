# This file is part of MXE.
# See index.html for further information.

PKG             := libzmq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.3
$(PKG)_CHECKSUM := 61b31c830db377777e417235a24d3660a4bcc3f40d303ee58df082fcd68bf411
$(PKG)_SUBDIR   := zeromq-$($(PKG)_VERSION)
$(PKG)_FILE     := zeromq-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.zeromq.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libsodium

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.zeromq.org/' | \
    $(SED) -n 's,.*zeromq-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        --without-libsodium
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
