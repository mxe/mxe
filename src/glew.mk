# This file is part of MXE.
# See index.html for further information.

PKG             := glew
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9291f5c5afefd482c7f3e91ffb3cd4716c6c9ffe
$(PKG)_SUBDIR   := glew-$($(PKG)_VERSION)
$(PKG)_FILE     := glew-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glew/glew/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/glew/files/glew/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Build libGLEW
    cd '$(1)' && $(TARGET)-gcc -O2 -DGLEW_STATIC -Iinclude -c -o glew.o src/glew.c
    cd '$(1)' && $(TARGET)-ar cr libGLEW.a glew.o
    $(TARGET)-ranlib '$(1)/libGLEW.a'
    $(SED) \
        -e "s|@prefix@|$(PREFIX)/$(TARGET)|g" \
        -e "s|@libdir@|$(PREFIX)/$(TARGET)/lib|g" \
        -e "s|@exec_prefix@|$(PREFIX)/$(TARGET)/bin|g" \
        -e "s|@includedir@|$(PREFIX)/$(TARGET)/include/GL|g" \
        -e "s|@version@|$(glew_VERSION)|g" \
        -e "s|@cflags@|-DGLEW_STATIC|g" \
        -e "s|-l@libname@|-lGLEW -lopengl32|g" \
        < '$(1)'/glew.pc.in > '$(1)'/glew.pc

    # Build libGLEWmx
    cd '$(1)' && $(TARGET)-gcc -O2 -DGLEW_STATIC -DGLEW_MX -Iinclude -c -o glewmx.o src/glew.c
    cd '$(1)' && $(TARGET)-ar cr libGLEWmx.a glewmx.o
    $(TARGET)-ranlib '$(1)/libGLEWmx.a'
    $(SED) \
        -e "s|@prefix@|$(PREFIX)/$(TARGET)|g" \
        -e "s|@libdir@|$(PREFIX)/$(TARGET)/lib|g" \
        -e "s|@exec_prefix@|$(PREFIX)/$(TARGET)/bin|g" \
        -e "s|@includedir@|$(PREFIX)/$(TARGET)/include/GL|g" \
        -e "s|@version@|$(glew_VERSION)|g" \
        -e "s|@cflags@|-DGLEW_STATIC -DGLEW_MX|g" \
        -e "s|-l@libname@|-lGLEWmx -lopengl32|g" \
        < '$(1)'/glew.pc.in > '$(1)'/glewmx.pc

    # Install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.a'
    $(INSTALL) -m644 '$(1)/libGLEWmx.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/glew.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -m644 '$(1)/glewmx.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'

    # Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glew.exe' \
        `'$(TARGET)-pkg-config' glew --cflags --libs`
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glewmx.exe' \
        `'$(TARGET)-pkg-config' glewmx --cflags --libs`
endef
