# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := ghostscript
$(PKG)_WEBSITE  := https://www.ghostscript.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.23
$(PKG)_NODOTVER := $(subst .,,$($(PKG)_VERSION))
$(PKG)_CHECKSUM := 1fcedc27d4d6081105cdf35606cb3f809523423a6cf9e3c23cead3525d6ae8d9
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$($(PKG)_NODOTVER)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dbus fontconfig freetype lcms libiconv libidn libjpeg-turbo libpaper libpng openjpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ghostscript.com/Releases.html' | \
    $(SED) -n 's:.*GPL_Ghostscript_::p' | \
    $(SED) -n 's:\.html.*::p'
endef

define $(PKG)_BUILD
    cd '$(SOURCE_DIR)' && rm -rf freetype jpeg libpng openjpeg tiff zlib
    cd '$(SOURCE_DIR)' && autoreconf -f -i
    cd '$(BUILD_DIR)' && CCAUX='$(BUILD_CC)' \
        CPPFLAGS='$(CPPFLAGS) -DHAVE_SYS_TIMES_H=0' \
        $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-exe-ext='.exe' \
        --with-drivers=ALL \
        --with-arch_h='$(SOURCE_DIR)/arch/windows-x$(if $(filter x86_64-%,$(TARGET)),64,86)-msvc.h' \
        --with-memory-alignment='$(if $(filter x86_64-%,$(TARGET)),8,4)' \
        --disable-contrib \
        --disable-cups \
        --disable-gtk \
        --with-libiconv=gnu \
        --with-system-libtiff \
        --without-ijs
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(if $(BUILD_STATIC),all libgs,so \
        CFLAGS_SO='' \
        GS_LDFLAGS_SO='-shared -Wl,--out-implib=sobin/libgs.dll.a' \
        GS_SONAME_MAJOR='libgs-ignore-me.dll' \
        GS_SONAME_MAJOR_MINOR='libgs-9.dll')

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/ghostscript'
    $(INSTALL) '$(SOURCE_DIR)/devices/gdevdsp.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gdevdsp.h'
    $(INSTALL) '$(SOURCE_DIR)/base/gserrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/gserrors.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/iapi.h' '$(PREFIX)/$(TARGET)/include/ghostscript/iapi.h'
    $(INSTALL) '$(SOURCE_DIR)/psi/ierrors.h' '$(PREFIX)/$(TARGET)/include/ghostscript/ierrors.h'

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    #$(INSTALL) '$(BUILD_DIR)/$(if $(BUILD_STATIC),bin/gs,sobin/gsc).exe' '$(PREFIX)/$(TARGET)/bin/gs.exe'
    $(if $(BUILD_STATIC),\
        $(INSTALL) '$(BUILD_DIR)/bin/gs.a' '$(PREFIX)/$(TARGET)/lib/libgs.a',\
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs-9.dll' '$(PREFIX)/$(TARGET)/bin/libgs-9.dll' && \
        $(INSTALL) '$(BUILD_DIR)/sobin/libgs.dll.a' '$(PREFIX)/$(TARGET)/lib/libgs.dll.a')

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: ghostscript'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: Ghostscript library'; \
     echo 'Cflags: -I"$(PREFIX)/$(TARGET)/include/ghostscript"'; \
     echo 'Cflags.private: -DGS_STATIC_LIB'; \
     echo 'Libs: -L"$(PREFIX)/$(TARGET)/lib" -lgs'; \
     echo 'Requires: fontconfig freetype2 libidn libtiff-4 libpng jpeg lcms2 zlib'; \
     echo '# https://github.com/mxe/mxe/issues/1446'; \
     echo 'Libs.private: -lm -liconv -lpaper -lopenjp2 -lwinspool';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/ghostscript.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-ghostscript.exe' \
        `$(TARGET)-pkg-config --cflags --libs ghostscript`
endef

