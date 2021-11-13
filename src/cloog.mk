# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cloog
$(PKG)_WEBSITE  := https://github.com/periscop/cloog
$(PKG)_DESCR    := CLooG Code Generator
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.20.0
$(PKG)_CHECKSUM := 835c49951ff57be71dcceb6234d19d2cc22a3a5df84aea0a9d9760d92166fc72
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/periscop/cloog/releases/download/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gmp isl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/periscop/cloog/releases' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)' \
        ac_cv_prog_TEXI2DVI=
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
