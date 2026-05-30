# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := openexr
$(PKG)_WEBSITE  := https://www.openexr.com/
$(PKG)_DESCR    := OpenEXR
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.12
$(PKG)_CHECKSUM := a455779c389f65c64220d45b63ead2900081e5f6337cdf93431cb1032c3e2686
$(PKG)_GH_CONF  := AcademySoftwareFoundation/openexr/tags,v
$(PKG)_DEPS     := cc imath pthreads zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DOPENEXR_INSTALL_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -Wall -Wextra -std=gnu++14 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-openexr.exe' \
        `'$(TARGET)-pkg-config' OpenEXR --cflags --libs`
endef
