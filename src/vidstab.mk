# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vidstab
$(PKG)_WEBSITE  := http://public.hronopik.de/vid.stab/features.php?lang=en
$(PKG)_DESCR    := vid.stab video stablizer
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.98b
$(PKG)_CHECKSUM := 530f0bf7479ec89d9326af3a286a15d7d6a90fcafbb641e3b8bdb8d05637d025
$(PKG)_SUBDIR   := vid.stab-release-$($(PKG)_VERSION)
$(PKG)_FILE     := vid.stab-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/georgmartius/vid.stab/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/georgmartius/vid.stab/tags' | \
    grep '<a href="/georgmartius/vid.stab/archive/' | \
    $(SED) -n 's,.*href="/georgmartius/vid.stab/archive/release-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' ..
    $(MAKE) -C '$(1)/build' -j $(JOBS)
    $(MAKE) -C '$(1)/build' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-vidstab.exe' \
        `'$(TARGET)-pkg-config' --static --cflags --libs vidstab`
endef
