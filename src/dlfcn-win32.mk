# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dlfcn-win32
$(PKG)_WEBSITE  := https://github.com/dlfcn-win32/dlfcn-win32
$(PKG)_DESCR    := POSIX dlfcn wrapper for Windows
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := e19bf07
$(PKG)_CHECKSUM := 6b31a8547547af27e5dfc092df1ea2c6ac562ce47b7ec08a0a4da4ed0b002767
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, dlfcn-win32/dlfcn-win32, master) | $(SED) 's/^\(.......\).*/\1/;'

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix='$(TARGET)-' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared )
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(MAKE) -C '$(1)' -j '$(JOBS)' test.exe testdll.dll

    # create pkg-config file - mostly for psapi dependency
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Libs: -ldl'; \
     echo 'Libs.private: -lpsapi'; \
    ) > '$(PREFIX)/$(TARGET)/lib/pkgconfig/dlfcn.pc'
endef
