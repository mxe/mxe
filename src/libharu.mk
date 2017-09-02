# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libharu
$(PKG)_WEBSITE  := http://libharu.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 8f9e68cc5d5f7d53d1bc61a1ed876add1faf4f91070dbc360d8b259f46d9a4d2
$(PKG)_GH_CONF  := libharu/libharu,RELEASE_,,,_
$(PKG)_DEPS     := gcc libpng zlib

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCMAKE_C_FLAGS=$(if $(BUILD_STATIC),,-DHPDF_DLL_MAKE) \
        -DLIBHPDF_SHARED=$(CMAKE_SHARED_BOOL) \
        -DLIBHPDF_STATIC=$(CMAKE_STATIC_BOOL) \
        -DDEVPAK=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    $(TARGET)-gcc -o $(PREFIX)/$(TARGET)/bin/test-$(PKG).exe \
        $(if $(BUILD_STATIC),,-DHPDF_DLL) \
        '$(1)/demo/slide_show_demo.c' \
        $(if $(BUILD_STATIC),'-lhpdfs','-lhpdf') \
        `$(TARGET)-pkg-config libpng zlib --libs`
endef
