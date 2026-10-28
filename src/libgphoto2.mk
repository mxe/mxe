# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgphoto2
$(PKG)_WEBSITE  := https://github.com/gphoto/libgphoto2
$(PKG)_DESCR    := libgphoto2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.34
$(PKG)_CHECKSUM := 37b476bf1af073219394210d34904d987b6cb8bfb64d5cc5b6e87c7d453d421a
$(PKG)_GH_CONF  := gphoto/libgphoto2/releases, v
$(PKG)_DEPS     := cc curl libexif libgnurx libltdl libusb1 libxml2

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --with-libusb=no \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        $(MXE_CONFIGURE_OPTS) \
        $(PKG_CONFIGURE_OPTS) \
        DEFAULT_CAMLIBS='./libgphoto2' \
        DEFAULT_IOLIBS='./libgphoto2_port' \
        CFLAGS='-Wno-implicit-function-declaration' \
        LDFLAGS='-lintl' \
        LIBLTDL='-lltdl -ldl'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libgphoto2 --cflags --libs` -lltdl -ldl -lintl -liconv -ladvapi32 -lregex
endef
