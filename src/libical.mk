# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libical
$(PKG)_WEBSITE  := https://libical.github.io/libical/
$(PKG)_VERSION  := 3.0.18
$(PKG)_CHECKSUM := 72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c
$(PKG)_GH_CONF  := libical/libical/releases/latest, v
$(PKG)_DEPS     := cc icu4c

define $(PKG)_BUILD
    # ical 2 is not compatible with C++17 or newer, so the build is forced to C++11.
    # ical 3.x is fine with newer C++.
    
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DUSE_BUILTIN_TZDATA=true \
        -DSTATIC_ONLY=$(CMAKE_STATIC_BOOL) \
        -DSHARED_ONLY=$(CMAKE_SHARED_BOOL) \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DCMAKE_POLICY_DEFAULT_CMP0074=NEW \
        -DLIBICAL_BUILD_TESTING=false \
        -DENABLE_GTK_DOC=OFF \
        -DICAL_GLIB=OFF \
        -DGOBJECT_INTROSPECTION=OFF \
        -DICU_ROOT='$(PREFIX)/$(TARGET)' \
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
