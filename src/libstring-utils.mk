# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libstring-utils
$(PKG)_WEBSITE  := https://github.com/crocarneiro/libstring-utils
$(PKG)_DESCR    := Library with some badass functions for strings in C.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.1
$(PKG)_CHECKSUM := 54d2cadafb36dce347a668ea18a20c7b2912f869d0842f0f954a5899c88d93e4
$(PKG)_GH_CONF  := crocarneiro/libstring-utils/releases/latest,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(SOURCE_DIR)' && autoreconf --install
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Requires:'; \
     echo 'Libs: -lstring-utils'; \
     echo 'Cflags.private:';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef