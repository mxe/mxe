# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := muparser
$(PKG)_WEBSITE  := https://beltoforion.de/article.php?a=muparser
$(PKG)_DESCR    := muParser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.5
$(PKG)_CHECKSUM := 0666ef55da72c3e356ca85b6a0084d56b05dd740c3c21d26d372085aa2c6e708
$(PKG)_GH_CONF  := beltoforion/muparser/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
