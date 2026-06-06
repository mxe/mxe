# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cloog
$(PKG)_WEBSITE  := https://github.com/periscop/cloog
$(PKG)_DESCR    := CLooG Code Generator
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.21.1
$(PKG)_CHECKSUM := d370cf9990d2be24bfb24750e355bac26110051248cabf2add61f9b3867fb1d7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/periscop/cloog/releases/download/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gmp isl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/periscop/cloog/releases' | \
    $(SED) -n 's,.*cloog-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-gmp-prefix='$(PREFIX)/$(TARGET)' \
        --with-isl-prefix='$(PREFIX)/$(TARGET)' \
        --with-osl=no \
        ac_cv_prog_TEXI2DVI=
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_SHARED),LDFLAGS=-no-undefined)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
