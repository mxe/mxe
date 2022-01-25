# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libgphoto2
$(PKG)_WEBSITE  := https://github.com/gphoto/libgphoto2
$(PKG)_DESCR    := libgphoto2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.27
$(PKG)_CHECKSUM := fd48f6f58259ba199e834010aca0af3672ca0223ed0a98ba89ec693a415f242a
$(PKG)_GH_CONF  := gphoto/libgphoto2/releases, v
$(PKG)_DEPS     := cc curl libltdl libxml2 libusb1 libexif

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
	--with-libusb=no \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        $(MXE_CONFIGURE_OPTS) \
        $(PKG_CONFIGURE_OPTS) \
        LDFLAGS='-lintl' \
        LIBLTDL='-lltdl -ldl'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install

    '$(TARGET)-gcc' \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libgphoto2 --cflags --libs` -lltdl -ldl -lintl -liconv -ladvapi32
endef
