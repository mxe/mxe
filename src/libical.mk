# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libical
$(PKG)_WEBSITE  := https://libical.github.io/libical/
$(PKG)_VERSION  := 2.0.0
$(PKG)_CHECKSUM := 654c11f759c19237be39f6ad401d917e5a05f36f1736385ed958e60cf21456da
$(PKG)_GH_CONF  := libical/libical/releases/latest, v
$(PKG)_DEPS     := cc icu4c

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DUSE_BUILTIN_TZDATA=true \
        -DSTATIC_ONLY=$(CMAKE_STATIC_BOOL) \
        -DSHARED_ONLY=$(CMAKE_SHARED_BOOL) \
        '$(SOURCE_DIR)'

    # libs are built twice, causing parallel failures
    # https://github.com/libical/libical/issues/174
    $(MAKE) -C '$(BUILD_DIR)' -j 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libical.exe' \
        `'$(TARGET)-pkg-config' libical --cflags --libs`
endef
