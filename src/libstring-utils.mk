# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libstring-utils
$(PKG)_WEBSITE  := https://github.com/crocarneiro/libstring-utils
$(PKG)_DESCR    := Library with some badass functions for strings in C.
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.3
$(PKG)_CHECKSUM := f453e4fa6e3632dc739e71d5437c6bd2df1099812fa5e770041d0e5e7765f29e
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
