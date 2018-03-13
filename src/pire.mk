# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pire
$(PKG)_WEBSITE  := https://github.com/yandex/pire
$(PKG)_DESCR    := PIRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := 85a9bd66fff568554826e4aff9b188ed6124e3ea0530cc561723b36aea2a58e3
$(PKG)_GH_CONF  := yandex/pire/tags,release-
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-extra \
        ac_cv_func_malloc_0_nonnull=yes
    $(MAKE) -C '$(BUILD_DIR)/pire' -j '$(JOBS)' bin_PROGRAMS= LDFLAGS='-no-undefined'
    $(MAKE) -C '$(BUILD_DIR)/pire' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(SOURCE_DIR)/samples/pigrep/pigrep.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lpire
endef
