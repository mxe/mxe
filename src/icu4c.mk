# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := icu4c
$(PKG)_WEBSITE  := http://site.icu-project.org/
$(PKG)_DESCR    := ICU4C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 56.1
$(PKG)_MAJOR    := $(word 1,$(subst ., ,$($(PKG)_VERSION)))
$(PKG)_CHECKSUM := 3a64e9105c734dcf631c0b3ed60404531bce6c0f5a64bfe1a6402a4cc2314816
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := http://download.icu-project.org/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://bugs.icu-project.org/trac/browser/icu/tags' | \
    $(SED) -n 's,.*release-\([0-9-]*\)<.*,\1,p' | \
    tr '-' '.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_COMMON
    cd '$(1)/source' && autoreconf -fi
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure' \
        CC=$(BUILD_CC) CXX=$(BUILD_CXX)
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

define $(PKG)_BUILD_SHARED
    $($(PKG)_BUILD_COMMON)
    # icu4c installs its DLLs to lib/. Move them to bin/.
    mv -fv $(PREFIX)/$(TARGET)/lib/icu*.dll '$(PREFIX)/$(TARGET)/bin/'
    # add symlinks icu*<version>.dll.a to icu*.dll.a
    for lib in `ls '$(PREFIX)/$(TARGET)/lib/' | grep 'icu.*\.dll\.a' | cut -d '.' -f 1 | tr '\n' ' '`; \
    do \
        ln -fs "$(PREFIX)/$(TARGET)/lib/$${lib}.dll.a" "$(PREFIX)/$(TARGET)/lib/$${lib}$($(PKG)_MAJOR).dll.a"; \
    done
endef

define $(PKG)_BUILD
    $($(PKG)_BUILD_COMMON)
    # Static libs are prefixed with an `s` but the config script
    # doesn't detect it properly, despite the STATIC_PREFIX="s" line
    $(SED) -i 's,ICUPREFIX="icu",ICUPREFIX="sicu",' '$(PREFIX)/$(TARGET)/bin/icu-config'
endef
