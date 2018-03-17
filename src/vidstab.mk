# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vidstab
$(PKG)_WEBSITE  := http://public.hronopik.de/vid.stab/features.php?lang=en
$(PKG)_DESCR    := vid.stab video stablizer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb
$(PKG)_GH_CONF  := georgmartius/vid.stab/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-vidstab.exe' \
        `'$(TARGET)-pkg-config' --static --cflags --libs vidstab`
endef
