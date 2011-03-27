# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# xvidcore
PKG             := xvidcore
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := 68c73b9a00dfb830083f619335eb876b0f845bec
$(PKG)_SUBDIR   := xvidcore/build/generic
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.xvid.org/
$(PKG)_URL      := http://downloads.xvid.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://www.xvid.org/' | \
    $(SED) -n 's,.*Xvid \([0-9][^ ]*\) .*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' BUILD_DIR='build' SHARED_LIB=
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/../../src/xvid.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/build/xvidcore.a' '$(PREFIX)/$(TARGET)/lib/'
    ln -sf $(PREFIX)/$(TARGET)/lib/xvidcore.a $(PREFIX)/$(TARGET)/lib/libxvidcore.a
endef
