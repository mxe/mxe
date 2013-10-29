# This file is part of MXE.
# See index.html for further information.

PKG             := icu4c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 51.1
$(PKG)_CHECKSUM := 7905632335e3dcd6667224da0fa087b49f9095e9
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := http://download.icu-project.org/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://bugs.icu-project.org/trac/browser/icu/tags' | \
    $(SED) -n 's,.*release-\([0-9-]*\)<.*,\1,p' | \
    tr '-' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure' \
        CC=gcc CXX=g++
    $(MAKE) -C '$(1).native' -j '$(JOBS)'

    mkdir '$(1).cross' && cd '$(1).cross' && '$(1)/source/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --with-cross-build='$(1).native' \
        CFLAGS=-DU_USING_ICU_NAMESPACE=0 \
        SHELL=bash

    $(MAKE) -C '$(1).cross' -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'

    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
