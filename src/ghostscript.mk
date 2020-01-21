# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ghostscript
$(PKG)_WEBSITE  := https://www.ghostscript.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.50
$(PKG)_NODOTVER := $(subst .,,$($(PKG)_VERSION))
$(PKG)_CHECKSUM := db9bb0817b6f22974e6d5ad751975f346420c2c86a0afcfe6b4e09c47803e7d4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$($(PKG)_NODOTVER)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus fontconfig freetype lcms libiconv libidn libpaper libpng openjpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/ArtifexSoftware/ghostpdl-downloads/releases' | \
    $(SED) -n 's,.*"ghostscript-\([0-9\.]*\)\.tar.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cp -f `automake --print-libdir`/{config.guess,config.sub,install-sh} '$(SOURCE_DIR)'
    cd '$(SOURCE_DIR)' && rm -rf freetype jpeg lcms2mt libpng openjpeg tiff
    cd '$(SOURCE_DIR)' && autoreconf -f -i
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        CPPFLAGS='$(CPPFLAGS) -DHAVE_SYS_TIMES_H=0' \
        $(MXE_CONFIGURE_OPTS) \
        --with-libiconv=gnu \
        --without-local-zlib
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_STATIC),libgs,so) || \
    $(MAKE) -C '$(BUILD_DIR)' -j '1' $(if $(BUILD_STATIC),libgs,so)

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/ghostscript'
    $(INSTALL) '$(SOURCE_DIR)/devices/gdevdsp.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gdevdsp.h'
    $(INSTALL) '$(SOURCE_DIR)/base/gserrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gserrors.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/iapi.h' '$(PREFIX)/$(TARGET)/include/ghostscript/iapi.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/ierrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/ierrors.h'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),$(INSTALL) '$(BUILD_DIR)/bin/gs.a' '$(PREFIX)/$(TARGET)/lib/libgs.a', \
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs-9.dll' '$(PREFIX)/$(TARGET)/bin/libgs-9.dll' && \
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs.dll.a' '$(PREFIX)/$(TARGET)/lib/libgs.dll.a')

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: ghostscript'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Ghostscript library'; \
     echo 'Cflags: -I"$(PREFIX)/$(TARGET)/include/ghostscript"'; \
     echo 'Libs: -L"$(PREFIX)/$(TARGET)/lib" -lgs'; \
     echo 'Requires: fontconfig freetype2 lcms2 libidn libtiff-4 libpng libopenjp2 libjpeg zlib'; \
     echo '# https://github.com/mxe/mxe/issues/1446'; \
     echo 'Libs.private: -lm -liconv -lpaper -lwinspool';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/ghostscript.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-ghostscript.exe' \
        `$(TARGET)-pkg-config --cflags --libs ghostscript`
endef

