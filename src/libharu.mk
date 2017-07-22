# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libharu
$(PKG)_WEBSITE  := http://libharu.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 34de0ed4e994d9c704339292740b8019c33e8538814e104d882508a33517d1a8
$(PKG)_SUBDIR   := libharu-RELEASE_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := $($(PKG)_SUBDIR).zip
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/RELEASE_$(subst .,_,$($(PKG)_VERSION)).zip
$(PKG)_DEPS     := gcc libpng zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libharu/libharu/tags' | \
    $(SED) -n 's,.*/archive/RELEASE_\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v 'RC' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DCMAKE_C_FLAGS=$(if $(BUILD_STATIC),,-DHPDF_DLL_MAKE) \
        -DLIBHPDF_SHARED=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DLIBHPDF_STATIC=$(if $(BUILD_STATIC),TRUE,FALSE) \
        -DDEVPAK=ON
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1
    $(TARGET)-gcc -o $(PREFIX)/$(TARGET)/bin/test-$(PKG).exe \
        $(if $(BUILD_STATIC),,-DHPDF_DLL) \
        '$(1)/demo/slide_show_demo.c' \
        $(if $(BUILD_STATIC),'-lhpdfs','-lhpdf') \
        `$(TARGET)-pkg-config libpng zlib --libs`
endef
