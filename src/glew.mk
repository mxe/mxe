# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# GLEW
PKG             := glew
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.0
$(PKG)_CHECKSUM := 9266f2360c1687a96f2ea06419671d370b2928d1
$(PKG)_SUBDIR   := glew-$($(PKG)_VERSION)
$(PKG)_FILE     := glew-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://glew.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glew/glew/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/glew/files/glew/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
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
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/glew.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glew.exe' \
        `'$(TARGET)-pkg-config' glew --cflags --libs`
endef
