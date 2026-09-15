# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libwatson-translate
$(PKG)_WEBSITE  := https://github.com/crocarneiro/libwatson-translate
$(PKG)_DESCR    := Library with functions to use Watson Translate API
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := 77acc44e8baecfb323115a0f809a98f89b3748f8cf614c184f879272a134d56f
$(PKG)_GH_CONF  := crocarneiro/libwatson-translate/releases/latest,v
$(PKG)_DEPS     := cc curl cjson

define $(PKG)_BUILD
    # build and install the library
    cd $(SOURCE_DIR) && autoreconf --install
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
    echo 'Libs: -lwatson-translate'; \
    echo 'Cflags.private:';) \
    > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef