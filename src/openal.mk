# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openal
$(PKG)_WEBSITE  := https://openal-soft.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.1
$(PKG)_CHECKSUM := 5c2f87ff5188b95e0dc4769719a9d89ce435b8322b4478b95dd4b427fe84b2e9
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://openal-soft.org/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := cc portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://openal-soft.org/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DALSOFT_EXAMPLES=FALSE \
        -DALSOFT_TESTS=FALSE \
        -DALSOFT_UTILS=FALSE
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' || $(MAKE) -C '$(BUILD_DIR)' -j 1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openal.exe' \
        `'$(TARGET)-pkg-config' openal --cflags --libs`
endef
