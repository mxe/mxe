# This file is part of MXE.
# See index.html for further information.

PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19
$(PKG)_CHECKSUM := a0033e37a547c52059d0bf8664a96ecdeeb66419
$(PKG)_SUBDIR   := $(PKG)-r$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://$(PKG).googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/dlfcn-win32/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*dlfcn-win32-r\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix='$(TARGET)-' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared )
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    # No test avalable temprorarily because MXE doesn't support shared build yet
endef
