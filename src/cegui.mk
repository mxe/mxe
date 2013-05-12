# This file is part of MXE.
# See index.html for further information.

PKG             := cegui
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f0a8616bcb37843ad2f83c88745b9313906cb8e9
$(PKG)_SUBDIR   := CEGUI-$($(PKG)_VERSION)
$(PKG)_FILE     := CEGUI-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/crayzedsgui/CEGUI%20Mk-2/$($(PKG)_VERSION)/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gcc pcre freeglut freeimage freetype libxml2 expat xerces

define $(PKG)_UPDATE
    echo 'TODO: Updates for package cegui need to be written.' >&2; echo $(cegui_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-freetype \
        --enable-pcre \
        --enable-xerces-c \
        --enable-libxml \
        --enable-expat \
        --disable-corona \
        --disable-devil \
        --enable-freeimage \
        --disable-silly \
        --enable-tga \
        --disable-tinyxml \
        --enable-stb \
        --enable-opengl-renderer \
        --disable-ogre-renderer \
        --disable-irrlicht-renderer \
        --disable-directfb-renderer \
        --enable-null-renderer \
        --disable-samples \
        --disable-lua-module \
        --disable-python-module \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        CFLAGS="`$(TARGET)-pkg-config --cflags glut freeimage`" \
        CXXFLAGS="`$(TARGET)-pkg-config --cflags glut freeimage`" \
        LDFLAGS="`$(TARGET)-pkg-config --libs glut freeimage`"
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(SED) -i 's/Cflags:\(.*\)/Cflags: \1 -DCEGUI_STATIC/' '$(1)/cegui/CEGUI.pc'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
         '$(2).cpp' \
         `'$(TARGET)-pkg-config' --cflags --libs CEGUI-OPENGL glut freetype2 libpcre` \
         -lCEGUIFreeImageImageCodec -lCEGUIXercesParser -lCEGUIFalagardWRBase \
         `'$(TARGET)-pkg-config' --libs --cflags freeimage xerces-c` \
         -o '$(PREFIX)/$(TARGET)/bin/test-cegui.exe'
endef
