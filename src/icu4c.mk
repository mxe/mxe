# This file is part of MXE.
# See index.html for further information.

PKG             := icu4c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 52.1
$(PKG)_CHECKSUM := 6de440b71668f1a65a9344cdaf7a437291416781
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

define $(PKG)_BUILD_SHARED
    cd '$(1)/source' && autoreconf -fi
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure' \
        CC=gcc CXX=g++
    $(MAKE) -C '$(1).native' -j '$(JOBS)'

    mkdir '$(1).cross' && cd '$(1).cross' && '$(1)/source/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-cross-build='$(1).native' \
        CFLAGS=-DU_USING_ICU_NAMESPACE=0 \
        CXXFLAGS='--std=gnu++0x' \
        SHELL=bash

    $(MAKE) -C '$(1).cross' -j '$(JOBS)' install
    ln -sf '$(PREFIX)/$(TARGET)/bin/icu-config' '$(PREFIX)/bin/$(TARGET)-icu-config'
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_SHARED)
    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
