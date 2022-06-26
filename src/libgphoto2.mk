# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgphoto2
$(PKG)_WEBSITE  := https://github.com/gphoto/libgphoto2
$(PKG)_DESCR    := libgphoto2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.28
$(PKG)_CHECKSUM := 35846402a6d1806a4fb73d590d410d44fd2cd14c99d927837c16801fd7fcbac9
$(PKG)_GH_CONF  := gphoto/libgphoto2/releases, v
$(PKG)_DEPS     := cc curl libltdl libxml2 libusb1 libexif

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --with-libusb=no \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        $(MXE_CONFIGURE_OPTS) \
        $(PKG_CONFIGURE_OPTS) \
        DEFAULT_CAMLIBS='./libgphoto2' \
        DEFAULT_IOLIBS='./libgphoto2_port' \
        LDFLAGS='-lintl' \
        LIBLTDL='-lltdl -ldl'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libgphoto2 --cflags --libs` -lltdl -ldl -lintl -liconv -ladvapi32
endef
