# This file is part of MXE.
# See index.html for further information.

PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := 864408870f2de9cdb7b198628ea346791f37d0c3
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/eroux/dlfcn-win32/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://github.com/eroux/dlfcn-win32/releases" | \
    grep '<a href=.*tar' | \
    $(SED) -n 's,.*dlfcn-win32-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)$(PKG)-$($(PKG)_VERSION)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix='$(TARGET)-' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared )
    $(MAKE) -C '$(1)$(PKG)-$($(PKG)_VERSION)' -j '$(JOBS)'
    $(MAKE) -C '$(1)$(PKG)-$($(PKG)_VERSION)' -j 1 install

    # No test avalable temprorarily because MXE doesn't support shared build yet
endef
