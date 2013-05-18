# This file is part of MXE.
# See index.html for further information.

PKG             := icu4c
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7905632335e3dcd6667224da0fa087b49f9095e9
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := http://download.icu-project.org/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package icu4c need to be written.' >&2;
    echo $(icu4c_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure'
    $(MAKE) -C '$(1).native' -j '$(JOBS)'

    $(SED) -i 's,\(baselibs.*\),\1 -lstdc++,' '$(1)/source/config/icu.pc.in'
    mkdir '$(1).cross' && cd '$(1).cross' && '$(1)/source/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --with-cross-build='$(1).native' \
        CFLAGS=-DU_USING_ICU_NAMESPACE=0 \
        SHELL=bash

    $(MAKE) -C '$(1).cross' -j '$(JOBS)' install LIBPREFIX=lib
    ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'

    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
