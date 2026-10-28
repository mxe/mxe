# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vidstab
$(PKG)_WEBSITE  := http://public.hronopik.de/vid.stab/features.php?lang=en
$(PKG)_DESCR    := vid.stab video stablizer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.2
$(PKG)_CHECKSUM := 96db34d48a9e3aa13736a48744b56dfb76731ac9bb5193c716de8534c9fd709d
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
