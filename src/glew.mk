# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glew
$(PKG)_WEBSITE  := https://glew.sourceforge.io/
$(PKG)_DESCR    := GLEW
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95
$(PKG)_SUBDIR   := glew-$($(PKG)_VERSION)
$(PKG)_FILE     := glew-$($(PKG)_VERSION).tgz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/glew/glew/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/glew/files/glew/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'mxe: lib $(if $(BUILD_STATIC), lib/$$(LIB.STATIC), lib/$$(LIB.SHARED))' >> '$(1)/Makefile'

    $(MAKE) -C '$(1)' \
        GLEW_DEST=$(PREFIX)/$(TARGET) \
        SYSTEM=linux-mingw32 \
        CC=$(TARGET)-gcc \
        LD=$(TARGET)-ld \
        NAME=GLEW \
        mxe glew.pc

    $(if $(BUILD_STATIC),
        $(TARGET)-ranlib '$(1)/lib/libGLEW.a'
        $(SED) -i -e "s|Cflags:|Cflags: -DGLEW_STATIC|g" '$(1)'/glew.pc
        $(SED) -i -e "s|Requires:|Requires: gl|g"        '$(1)'/glew.pc
    )
    $(SED) -i -e "s|prefix=/usr|prefix=$(PREFIX)/$(TARGET)|g" '$(1)'/glew.pc

    # Install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.a'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32.a'
    ,
        $(INSTALL) -m644 '$(1)/lib/GLEW.dll' '$(PREFIX)/$(TARGET)/bin/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(PREFIX)/$(TARGET)/lib/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.dll.a'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(PREFIX)/$(TARGET)/lib/libglew32.dll.a'
    )
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/glew.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        `'$(TARGET)-pkg-config' glew --cflags` \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-glew.exe' \
        `'$(TARGET)-pkg-config' glew --libs`
endef
