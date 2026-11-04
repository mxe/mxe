# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freeimage
$(PKG)_WEBSITE  := https://github.com/danoli3/FreeImage
$(PKG)_DESCR    := FreeImage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := ee7b3ca
$(PKG)_CHECKSUM := fc0e21b5bfdf1fec33bc63b01656f7d5bf86943737b05f95112e6ae479d6f094
$(PKG)_GH_CONF  := danoli3/FreeImage/branches/master
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B $(BUILD_DIR) \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DBUILD_TESTS=OFF \
        $(PKG_CMAKE_OPTS)
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --parallel '$(JOBS)' --verbose
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'

    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: freeimage'; \
     echo 'Version: $(freeimage_VERSION)'; \
     echo 'Description: FreeImage'; \
     echo 'Cflags: $(if $(BUILD_STATIC),-DFREEIMAGE_LIB,)'; \
     echo 'Libs: -lFreeImage -lws2_32 -lstdc++';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/freeimage.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(PWD)/src/$(PKG)-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-freeimage.exe' \
        `'$(TARGET)-pkg-config' freeimage --cflags --libs`
endef
