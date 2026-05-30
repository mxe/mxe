# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vidstab
$(PKG)_WEBSITE  := http://public.hronopik.de/vid.stab/features.php?lang=en
$(PKG)_DESCR    := vid.stab video stablizer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.1
$(PKG)_CHECKSUM := 9001b6df73933555e56deac19a0f225aae152abbc0e97dc70034814a1943f3d4
$(PKG)_GH_CONF  := georgmartius/vid.stab/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-vidstab.exe' \
        `'$(TARGET)-pkg-config' --static --cflags --libs vidstab`
endef
