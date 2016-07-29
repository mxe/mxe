# This file is part of MXE.
# See index.html for further information.

PKG             := cegui
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.7
$(PKG)_CHECKSUM := b351e8957716d9c170612c13559e49530ef911ae4bac2feeb2dacd70b430e518
$(PKG)_SUBDIR   := cegui-$($(PKG)_VERSION)
$(PKG)_FILE     := cegui-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/crayzedsgui/CEGUI%20Mk-2/0.8/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gcc expat freeglut freeimage freetype libxml2 pcre xerces devil glm glew

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/cegui/cegui/downloads' | \
    $(SED) -n 's,.*href=.*get/v\([0-9]*-[0-9]*-[0-9]*\)\.tar.*,\1,p' | \
    $(SED) 's,-,.,g' | \
    $(SORT) -V | \
    tail -1
endef

# Use pkg-config to set FREEIMAGE_LIB and GLEW_STATIC to prevent "_imp__" errors
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DCEGUI_BUILD_STATIC_CONFIGURATION=$(CMAKE_STATIC_BOOL) \
        -DCEGUI_SAMPLES_ENABLED=OFF \
        -DCEGUI_BUILD_TESTS=OFF \
        -DCEGUI_BUILD_APPLICATION_TEMPLATES=OFF \
        -DCEGUI_BUILD_LUA_MODULE=OFF \
        -DCEGUI_BUILD_PYTHON_MODULES=OFF \
        -DCEGUI_BUILD_XMLPARSER_XERCES=ON \
        -DCEGUI_BUILD_XMLPARSER_LIBXML2=OFF \
        -DCEGUI_BUILD_XMLPARSER_EXPAT=ON \
        -DCEGUI_BUILD_XMLPARSER_TINYXML=OFF \
        -DCEGUI_BUILD_XMLPARSER_RAPIDXML=OFF \
        -DCEGUI_BUILD_IMAGECODEC_CORONA=OFF \
        -DCEGUI_BUILD_IMAGECODEC_DEVIL=OFF \
        -DCEGUI_BUILD_IMAGECODEC_FREEIMAGE=ON \
        -DCEGUI_BUILD_IMAGECODEC_PVR=OFF \
        -DCEGUI_BUILD_IMAGECODEC_SDL2=OFF \
        -DCEGUI_BUILD_IMAGECODEC_SILLY=OFF \
        -DCEGUI_BUILD_IMAGECODEC_STB=ON \
        -DCEGUI_BUILD_IMAGECODEC_TGA=ON \
        -DCEGUI_BUILD_RENDERER_DIRECT3D10=OFF \
        -DCEGUI_BUILD_RENDERER_DIRECT3D11=OFF \
        -DCEGUI_BUILD_RENDERER_DIRECT3D9=OFF \
        -DCEGUI_BUILD_RENDERER_DIRECTFB=OFF \
        -DCEGUI_BUILD_RENDERER_IRRLICHT=OFF \
        -DCEGUI_BUILD_RENDERER_NULL=ON \
        -DCEGUI_BUILD_RENDERER_OGRE=OFF \
        -DCEGUI_BUILD_RENDERER_OPENGL=ON \
        -DCEGUI_BUILD_RENDERER_OPENGL3=OFF \
        -DCEGUI_BUILD_RENDERER_OPENGLES=OFF \
        -DCMAKE_CXX_FLAGS="`$(TARGET)-pkg-config --cflags glew freeimage`" \
        $(SOURCE_DIR)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-cegui.exe' \
        `$(TARGET)-pkg-config --cflags --libs CEGUI-0-OPENGL glut gl`
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
