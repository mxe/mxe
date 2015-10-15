# This file is part of MXE.
# See index.html for further information.

PKG             := glew
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.0
$(PKG)_CHECKSUM := af58103f4824b443e7fa4ed3af593b8edac6f3a7be3b30911edbc7344f48e4bf
$(PKG)_SUBDIR   := glew-$($(PKG)_VERSION)
$(PKG)_FILE     := glew-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glew/glew/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/glew/files/glew/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    echo 'mxe: lib $(if $(BUILD_STATIC), lib/$$(LIB.STATIC) lib/$$(LIB.STATIC.MX), lib/$$(LIB.SHARED) lib/$$(LIB.SHARED.MX))' >> '$(1)/Makefile'

    # GCC 4.8.2 seems to miscompile the shared DLL with -O2
    $(MAKE) -C '$(1)' \
        GLEW_DEST=$(PREFIX)/$(TARGET) \
        SYSTEM=linux-mingw32 \
        CC=$(TARGET)-gcc \
        LD=$(TARGET)-ld \
        NAME=GLEW \
        $(if $(BUILD_SHARED),POPT=-O0) \
        mxe glew.pc glewmx.pc

    $(if $(BUILD_STATIC),
        $(TARGET)-ranlib '$(1)/lib/libGLEW.a'
        $(TARGET)-ranlib '$(1)/lib/libGLEWmx.a'
        $(SED) -i -e "s|Cflags:|Cflags: -DGLEW_STATIC|g" '$(1)'/glew.pc '$(1)'/glewmx.pc
        $(SED) -i -e "s|Requires:|Requires: gl|g"        '$(1)'/glew.pc '$(1)'/glewmx.pc
    )
    $(SED) -i -e "s|prefix=/usr|prefix=$(PREFIX)/$(TARGET)|g" '$(1)'/glew.pc '$(1)'/glewmx.pc

    # Install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC),
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(1)/lib/libGLEWmx.a' '$(PREFIX)/$(TARGET)/lib/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.a'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32.a'
    ,
        $(INSTALL) -m644 '$(1)/lib/GLEW.dll' '$(1)/lib/GLEWmx.dll' '$(PREFIX)/$(TARGET)/bin/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(1)/lib/libGLEWmx.dll.a' '$(PREFIX)/$(TARGET)/lib/'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.dll.a'
        $(INSTALL) -m644 '$(1)/lib/libGLEW.dll.a' '$(PREFIX)/$(TARGET)/lib/libglew32.dll.a'
    )
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/glew.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -m644 '$(1)/glewmx.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        `'$(TARGET)-pkg-config' glew --cflags` \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glew.exe' \
        `'$(TARGET)-pkg-config' glew --libs`
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        `'$(TARGET)-pkg-config' glewmx --cflags` \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glewmx.exe' \
        `'$(TARGET)-pkg-config' glewmx --libs`
endef
