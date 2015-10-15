# This file is part of MXE.
# See index.html for further information.

PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 36f2e7ef1f1ba04f6ce682a71937eaddd3d6994f09e29df2c7578ec524e47450
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/dlfcn-win32/dlfcn-win32/releases' | \
    $(SED) -n 's,.*<a href="/dlfcn-win32/dlfcn-win32/archive/v\([0-9][^>]*\)\.tar.*,\1,p' | \
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
