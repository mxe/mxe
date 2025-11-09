# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ccache
$(PKG)_WEBSITE  := https://ccache.samba.org
$(PKG)_DESCR    := ccache – a fast compiler cache
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.12.1
$(PKG)_CHECKSUM := 42e6c4b260cffd92dfa755e26390f45f5842e8c1a5f64f2b2e68adfbe82d1542
$(PKG)_SUBDIR   := ccache-$($(PKG)_VERSION)
$(PKG)_FILE     := ccache-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/ccache/ccache/releases/download/v$($(PKG)_VERSION)/ccache-$($(PKG)_VERSION).tar.xz
$(PKG)_DEPS     := $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://www.samba.org/ftp/ccache)
endef

BOOTSTRAP_PKGS += ccache

$(PKG)_SYS_CONF := $(MXE_CCACHE_DIR)/etc/$(PKG).conf
$(PKG)_USR_CONF := $(MXE_CCACHE_CACHE_DIR)/$(PKG).conf

ifeq (mxe,$(MXE_USE_CCACHE))
define $(PKG)_BUILD_$(BUILD)
    # remove any previous symlinks
    rm -fv '$(PREFIX)/$(BUILD)/bin/$(BUILD_CC)' '$(PREFIX)/$(BUILD)/bin/$(BUILD_CXX)'

    cd '$(BUILD_DIR)' && \
        cmake $(SOURCE_DIR) \
        -G Ninja \
        -DENABLE_DOCUMENTATION=OFF \
        -DENABLE_TESTING=OFF \
        -DZSTD_FROM_INTERNET=ON \
        -DHIREDIS_FROM_INTERNET=ON \
        -DCMAKE_INSTALL_PREFIX='$(MXE_CCACHE_DIR)' && \
    ninja install

    # setup symlinks
    ln -sf '$(MXE_CCACHE_DIR)/bin/ccache' '$(PREFIX)/$(BUILD)/bin/$(BUILD_CC)'
    ln -sf '$(MXE_CCACHE_DIR)/bin/ccache' '$(PREFIX)/$(BUILD)/bin/$(BUILD_CXX)'

    # https://ccache.samba.org/manual/latest.html#_configuration_settings
    # always set/replace mxe `system` config
    mkdir -p '$(dir $($(PKG)_SYS_CONF))'
    (echo '# ccache system config'; \
     echo '# this file is controlled by mxe, user config is in:'; \
     echo '# $($(PKG)_USR_CONF)'; \
     echo; \
     echo 'base_dir = $(MXE_CCACHE_BASE_DIR)'; \
     echo 'cache_dir = $(MXE_CCACHE_CACHE_DIR)'; \
     echo 'compiler_check = %compiler% -v'; \
     ) > '$($(PKG)_SYS_CONF)'

    # leave user config alone if set
    [ -f '$($(PKG)_USR_CONF)' ] || \
    (mkdir -p '$(dir $($(PKG)_USR_CONF))' && \
    (echo '# ccache user config'; \
     echo '# https://ccache.samba.org/manual/latest.html#_configuration_settings'; \
     echo '# system config: $($(PKG)_SYS_CONF)'; \
     echo; \
     echo 'max_size = 20.0G'; \
     ) > '$($(PKG)_USR_CONF)')
endef

define $(PKG)_BUILD
    # setup symlinks
    ln -sf '$(MXE_CCACHE_DIR)/bin/ccache' '$(PREFIX)/$(BUILD)/bin/$(TARGET)-gcc'
    ln -sf '$(MXE_CCACHE_DIR)/bin/ccache' '$(PREFIX)/$(BUILD)/bin/$(TARGET)-g++'

    # setup cmake toolchain to allow runtime override
    # CMAKE_CXX_COMPILER_LAUNCHER shows original cc and isn't clear in logs etc.
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    (echo 'option(MXE_USE_CCACHE "Enable ccache by default" ON)'; \
     echo 'if(MXE_USE_CCACHE)'; \
     echo '  set(CMAKE_C_COMPILER $(PREFIX)/$(BUILD)/bin/$(TARGET)-gcc)'; \
     echo '  set(CMAKE_CXX_COMPILER $(PREFIX)/$(BUILD)/bin/$(TARGET)-g++)'; \
     echo 'endif()'; \
     ) > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef
else
define $(PKG)_BUILD_$(BUILD)
    # remove symlinks
    rm -fv '$(PREFIX)/$(BUILD)/bin/$(BUILD_CC)' '$(PREFIX)/$(BUILD)/bin/$(BUILD_CXX)'
endef

define $(PKG)_BUILD
    # remove symlinks and cmake toolchain
    rm -fv '$(PREFIX)/$(BUILD)/bin/$(TARGET)-'*
    rm -fv '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef
endif
