# This file is part of MXE.
# See index.html for further information.

PKG             := lensfun
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.8
$(PKG)_CHECKSUM := 0e85eb7692620668d27e2303687492ad68c90eb4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lensfun/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libpng glib libgnurx

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lensfun/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_INSTALL_SHARED
    # lensfun's shared lib installation is a little bit non-MinGW-friendly:
    # * its DLL is installed to usr/TARGET/lib
    # * it doesn't install import lib
    # This macro fixes that.
    rm '$(PREFIX)/$(TARGET)/lib/lensfun.dll'
    cd '$(1)' && \
        $(INSTALL) -m 0755 'out/windows.x86/release/lensfun.dll' \
            '$(PREFIX)/$(TARGET)/bin/lensfun.dll' && \
        $(INSTALL) -m 0644 'out/windows.x86/release/lensfun.dll.a' \
            '$(PREFIX)/$(TARGET)/lib/lensfun.dll.a'
endef

define $(PKG)_BUILD
    $(SED) -i 's,/usr/bin/python,/usr/bin/env python,' '$(1)/configure'
    $(SED) -i 's,make ,$(MAKE) ,'                      '$(1)/configure'
    cd '$(1)' && \
        TKP='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --sdkdir='$(PREFIX)/$(TARGET)' \
        --compiler=gcc \
        --target=windows.x86 \
        --mode=release \
        --vectorization= \
        --staticlibs=$(if $(BUILD_STATIC),YES,NO)
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs V=1
    $(MAKE) -C '$(1)' -j 1 install-lensdb install-lensfun-pc install-lensfun V=1
    $(if $(BUILD_SHARED),$($(PKG)_INSTALL_SHARED),)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lensfun.exe' \
        `'$(TARGET)-pkg-config' lensfun --cflags --libs`
endef
