# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmad
$(PKG)_WEBSITE  := http://www.underbit.com/products/mad/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.15.1b
$(PKG)_CHECKSUM := bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/mad/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mad/files/libmad/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i '/-fforce-mem/d' '$(SOURCE_DIR)'/configure.ac
    # configure script is ancient so regenerate
    touch '$(SOURCE_DIR)'/{NEWS,AUTHORS,ChangeLog}
    cd '$(SOURCE_DIR)' && autoreconf -fi
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' LDFLAGS='-no-undefined'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
