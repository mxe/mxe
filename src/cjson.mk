# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cjson
$(PKG)_WEBSITE  := https://github.com/DaveGamble/cJSON
$(PKG)_DESCR    := C JSON Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.12
$(PKG)_CHECKSUM := 760687665ab41a5cff9c40b1053c19572bcdaadef1194e5cba1b5e6f824686e7
$(PKG)_GH_CONF  := DaveGamble/cJSON/releases/latest,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
    echo 'Version: $($(PKG)_VERSION)'; \
    echo 'Description: $($(PKG)_DESCR)'; \
    echo 'Requires:'; \
    echo 'Libs: -lcJSON'; \
    echo 'Cflags.private:';) \
    > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'
endef