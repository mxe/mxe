# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pkgconf
$(PKG)_WEBSITE  := https://github.com/pkgconf/pkgconf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := da179fd
$(PKG)_CHECKSUM := 91b2e5d7ce06583d5920c373b61d7d6554cd085cbd61ed176c7ff7ff3032523d
$(PKG)_GH_CONF  := pkgconf/pkgconf/branches/master
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := $(BUILD)~$(PKG)
$(PKG)_DEPS_$(BUILD) := libtool

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pkgconf.' >&2;
    echo $(pkgconf_VERSION)
endef

define $(PKG)_BUILD
    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$(PREFIX)/$(TARGET)/qt5/lib/pkgconfig":"$$PKG_CONFIG_PATH_$(subst .,_,$(subst -,_,$(TARGET)))" \
           PKG_CONFIG_SYSROOT_DIR= \
           PKG_CONFIG_LIBDIR="$(PREFIX)/$(TARGET)/lib/pkgconfig" \
           PKG_CONFIG_SYSTEM_INCLUDE_PATH="$(PREFIX)/$(TARGET)/include" \
           PKG_CONFIG_SYSTEM_LIBRARY_PATH="$(PREFIX)/$(TARGET)/lib" \
           exec "$(PREFIX)/$(BUILD)/bin/pkgconf" $(if $(BUILD_STATIC),--static) "$$@"') \
             > '$(PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-pkg-config'

    # create cmake file
    # either of these before `project` command will find native
    # `pkg-config` regardless of CACHE FORCE setting in toolchain
    #   - find_package(PkgConfig)
    #   - include(FindPkgConfig)
    #
    # it seems the `project` command loads CMAKE_TOOLCHAIN_FILE
    # but that isn't documented anywhere
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    (echo 'if(PKG_CONFIG_FOUND)'; \
     echo '  message(FATAL_ERROR "'; \
     echo '  ** find_package(PkgConfig) or (deprecated) include(FindPkgConfig)'; \
     echo '  ** must be invoked after project() command when using CMAKE_TOOLCHAIN_FILE'; \
     echo '  ")'; \
     echo 'endif()'; \
     echo 'set(PKG_CONFIG_EXECUTABLE $(PREFIX)/bin/$(TARGET)-pkg-config CACHE PATH "pkg-config executable")'; \
    )> '$(CMAKE_TOOLCHAIN_DIR)/pkgconf.cmake'
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(SOURCE_DIR)' && ./autogen.sh
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
