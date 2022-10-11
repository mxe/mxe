# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgphoto2
$(PKG)_WEBSITE  := https://github.com/gphoto/libgphoto2
$(PKG)_DESCR    := libgphoto2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.30
$(PKG)_CHECKSUM := 3e7eb9500fbf73ffaf4aa5eb65efde1998fb7ac702e689c274aacf52646f7ea4
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
        LDFLAGS='-lintl' \
        LIBLTDL='-lltdl -ldl'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libgphoto2 --cflags --libs` -lltdl -ldl -lintl -liconv -ladvapi32 -lregex
endef
