# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ghostscript
$(PKG)_WEBSITE  := https://www.ghostscript.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.19
$(PKG)_NODOTVER := $(subst .,,$($(PKG)_VERSION))
$(PKG)_CHECKSUM := f67acdcfcde1f86757ff3553cd719f12eac2d7681a0e96d8bdd1f40a0f47b45b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$($(PKG)_NODOTVER)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus fontconfig freetype lcms libiconv libidn libjpeg-turbo libpaper libpng openjpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ghostscript.com/Releases.html' | \
    $(SED) -n 's:.*GPL_Ghostscript_::p' | \
    $(SED) -n 's:\.html.*::p'
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && rm -rf freetype jpeg lcms2 libpng openjpeg tiff zlib
    cd '$(SOURCE_DIR)' && $(LIBTOOLIZE) --force --copy --install
    cd '$(SOURCE_DIR)' && autoconf -f -i
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-contrib \
        --enable-threading \
        --enable-fontconfig \
        --enable-dbus \
        --enable-freetype \
        --disable-cups \
        --enable-openjpeg \
        --disable-gtk \
        --with-libiconv=gnu \
        --with-libidn \
        --with-libpaper \
        --with-system-libtiff \
        --with-ijs \
        --with-luratech \
        --with-jbig2dec \
        --with-omni \
        --without-x \
        --with-drivers=ALL \
        --with-memory-alignment=$(if $(filter x86_64-%,$(TARGET)),8,4)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 $(if $(BUILD_STATIC),gs.a,so)

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/ghostscript'
    $(INSTALL) '$(SOURCE_DIR)/devices/gdevdsp.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gdevdsp.h'
    $(INSTALL) '$(SOURCE_DIR)/base/gserrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gserrors.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/iapi.h' '$(PREFIX)/$(TARGET)/include/ghostscript/iapi.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/ierrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/ierrors.h'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),\
        $(INSTALL) '$(BUILD_DIR)/gs.a' '$(PREFIX)/$(TARGET)/lib/libgs.a',\
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs-9.dll' '$(PREFIX)/$(TARGET)/bin/libgs-9.dll' && \
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs.dll.a' '$(PREFIX)/$(TARGET)/lib/libgs.dll.a')

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: ghostscript'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Ghostscript library'; \
     echo 'Cflags: -I"$(PREFIX)/$(TARGET)/include/ghostscript"'; \
     echo 'Cflags.private: -DGS_STATIC_LIB'; \
     echo 'Libs: -L"$(PREFIX)/$(TARGET)/lib" -lgs'; \
     echo 'Requires: libidn libtiff-4 libpng jpeg lcms2 zlib'; \
     echo '# https://github.com/mxe/mxe/issues/1446'; \
     echo 'Libs.private: -lm -liconv -lpaper -lopenjp2 -lwinspool';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/ghostscript.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-ghostscript.exe' \
        `$(TARGET)-pkg-config --cflags --libs ghostscript`
endef
