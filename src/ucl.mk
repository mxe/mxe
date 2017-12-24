# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ucl
$(PKG)_WEBSITE  := https://www.oberhumer.com/opensource/ucl/
$(PKG)_DESCR    := UCL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.03
$(PKG)_CHECKSUM := b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348
$(PKG)_SUBDIR   := ucl-$($(PKG)_VERSION)
$(PKG)_FILE     := ucl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.oberhumer.com/opensource/ucl/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.oberhumer.com/opensource/ucl/' | \
    $(SED) -n 's,.*ucl-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # configure script is ancient and isn't easy to regenerate
    # filter out invalid options
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(subst docdir$(comma),,$(MXE_CONFIGURE_OPTS)) \
        CFLAGS='-std=gnu90 -fPIC'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
