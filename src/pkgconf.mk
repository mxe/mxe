# This file is part of MXE.
# See index.html for further information.

PKG             := pkgconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := da179fd
$(PKG)_CHECKSUM := 91b2e5d7ce06583d5920c373b61d7d6554cd085cbd61ed176c7ff7ff3032523d
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     :=

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, pkgconf/pkgconf, master)

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pkgconf.' >&2;
    echo $(pkgconf_VERSION)
endef

define $(PKG)_BUILD
    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$(PREFIX)/$(TARGET)/qt5/lib/pkgconfig":"$$PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))" PKG_CONFIG_LIBDIR='\''$(PREFIX)/$(TARGET)/lib/pkgconfig'\'' exec '$(PREFIX)/$(BUILD)/bin/pkgconf' $(if $(BUILD_STATIC),--static) "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'

    # create cmake file
    echo 'set(PKG_CONFIG_EXECUTABLE $(PREFIX)/bin/$(TARGET)-pkg-config CACHE PATH "pkg-config executable")' \
    > '$(CMAKE_TOOLCHAIN_DIR)/pkgconf.cmake'

endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
