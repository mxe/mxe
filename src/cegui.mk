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

# Does not detect the freetype header directory otherwise
#$(PKG)_CXXFLAGS := -I/home/quintus/repos/privat/projekte/misc/mxe/usr/i686-w64-mingw32.static/include/freetype2 -I/home/quintus/repos/privat/projekte/misc/mxe/usr/i686-w64-mingw32.static/include

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/cegui/cegui/downloads' | \
    $(SED) -n 's,.*href=.*get/v\([0-9]*-[0-9]*-[0-9]*\)\.tar.*,\1,p' | \
    $(SED) 's,-,.,g' | \
    $(SORT) -V | \
    tail -1
endef

# The shell escape is required to make CEGUI find the freetype2 header
# directory, and to define the FREEIMAGE_LIB macro that prevents "_imp__"
# errors when linking to freeimage. The glew one is required to
# define GLEW_STATIC, but this is not completed yet (still gives "_imp__"
# errors on glew).
#    cd '$(1)' && $(PATCH) < $(TOP_DIR)/src/cegui-find-glew32.patch
define $(PKG)_BUILD
    mkdir '$(1)/build'
    $(PATCH) '$(1)/cmake/FindGLEW.cmake' '$(TOP_DIR)/src/cegui-find-glew32.patch'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_CXX_FLAGS="$($(PKG)_CXXFLAGS) $(shell $(TARGET)-pkg-config --cflags freetype2 glew freeimage)" \
        -DCEGUI_BUILD_STATIC_CONFIGURATION=$(if $(BUILD_STATIC),true,false) \
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
        -DCEGUI_BUILD_RENDERER_OPENGLES=OFF

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-cegui.exe' \
        `$(TARGET)-pkg-config --cflags --libs CEGUI-0-OPENGL glut freetype2 libpcre` \
        -lCEGUIFreeImageImageCodec -lCEGUIXercesParser -lCEGUICoreWindowRendererSet \
        `$(TARGET)-pkg-config --libs --cflags freeimage xerces-c`
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
