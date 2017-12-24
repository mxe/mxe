# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cegui
$(PKG)_WEBSITE  := http://cegui.org.uk/
$(PKG)_DESCR    := Crazy Eddie’s GUI System (CEGUI)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9726a2b505fb
$(PKG)_CHECKSUM := 14b3da7f1f89693192cd9afbf2126f4519508245ed156de893828e31ce676e9e
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc expat freeglut freeimage freetype fribidi glew \
                   glfw3 glm libxml2 minizip pcre xerces

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/cegui/cegui/downloads' | \
    $(SED) -n 's,.*href=.*get/v\([0-9]*-[0-9]*-[0-9]*\)\.tar.*,\1,p' | \
    $(SED) 's,-,.,g' | \
    $(SORT) -V | \
    tail -1
endef

# track dev branch v0-8 until next release
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/cegui/cegui/commits/branch/v0-8' | \
    $(SED) -n 's,.*cegui/cegui/commits/\([^?]\{12\}\).*at=.*,\1,p' | \
    head -1
endef

# Use pkg-config to set FREEIMAGE_LIB and GLEW_STATIC to prevent "_imp__" errors
# freeimage and xerces don't have shared builds - disable with $(CMAKE_STATIC_BOOL)
# devil appears to be dead, tinyxml is deprecated, lua needs toluapp
# boost and sdl2 aren't detected
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DCEGUI_BUILD_SHARED_CONFIGURATION=$(CMAKE_SHARED_BOOL) \
        -DCEGUI_BUILD_STATIC_CONFIGURATION=$(CMAKE_STATIC_BOOL) \
        -DCEGUI_BUILD_STATIC_FACTORY_MODULE=$(CMAKE_STATIC_BOOL) \
        -DCEGUI_INSTALL_PKGCONFIG=ON \
        -DCEGUI_SAMPLES_ENABLED=OFF \
        -DCEGUI_BUILD_TESTS=OFF \
        -DCEGUI_BUILD_APPLICATION_TEMPLATES=OFF \
        -DCEGUI_BUILD_LUA_MODULE=OFF \
        -DCEGUI_BUILD_PYTHON_MODULES=OFF \
        -DCEGUI_BUILD_XMLPARSER_XERCES=$(CMAKE_STATIC_BOOL) \
        -DCEGUI_BUILD_XMLPARSER_LIBXML2=ON \
        -DCEGUI_BUILD_XMLPARSER_EXPAT=ON \
        -DCEGUI_BUILD_XMLPARSER_TINYXML=OFF \
        -DCEGUI_BUILD_XMLPARSER_RAPIDXML=OFF \
        -DCEGUI_BUILD_IMAGECODEC_CORONA=OFF \
        -DCEGUI_BUILD_IMAGECODEC_DEVIL=OFF \
        -DCEGUI_BUILD_IMAGECODEC_FREEIMAGE=$(CMAKE_STATIC_BOOL) \
        -DCEGUI_BUILD_IMAGECODEC_PVR=OFF \
        -DCEGUI_BUILD_IMAGECODEC_SDL2=OFF \
        -DCEGUI_BUILD_IMAGECODEC_SILLY=OFF \
        -DCEGUI_BUILD_IMAGECODEC_STB=ON \
        -DCEGUI_BUILD_IMAGECODEC_TGA=ON \
        -DCEGUI_BUILD_RENDERER_DIRECT3D10=ON \
        -DCEGUI_BUILD_RENDERER_DIRECT3D11=OFF \
        -DCEGUI_BUILD_RENDERER_DIRECT3D9=ON \
        -DCEGUI_BUILD_RENDERER_DIRECTFB=OFF \
        -DCEGUI_BUILD_RENDERER_IRRLICHT=OFF \
        -DCEGUI_BUILD_RENDERER_NULL=ON \
        -DCEGUI_BUILD_RENDERER_OGRE=OFF \
        -DCEGUI_BUILD_RENDERER_OPENGL=ON \
        -DCEGUI_BUILD_RENDERER_OPENGL3=ON \
        -DCEGUI_BUILD_RENDERER_OPENGLES=OFF \
        -DCMAKE_CXX_FLAGS="`$(TARGET)-pkg-config --cflags glew freeimage`" \
        $(SOURCE_DIR)

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    # reconfigure pc files
    # https://bitbucket.org/cegui/cegui/issues/1135/pkg-config-files-not-installed-when-using#comment-29605718
    $(SED) -i 's/Requires:\(.*\)/Requires: \1 gl glew glut/' '$(PREFIX)/$(TARGET)/lib/pkgconfig/CEGUI-0-OPENGL.pc'
    $(if $(BUILD_STATIC),\
        $(SED) -i 's#\(-lCEGUI.*-0\>\)#\1_Static#g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/CEGUI-0'*.pc
        (echo 'Libs: -lCEGUIFreeImageImageCodec_Static \
                     -lCEGUIXercesParser_Static \
                     -lCEGUICoreWindowRendererSet_Static';\
         echo 'Requires.private: freeimage freetype2 libpcre xerces-c';\
         echo 'Cflags.private: -DCEGUI_STATIC';\
        ) >> '$(PREFIX)/$(TARGET)/lib/pkgconfig/CEGUI-0.pc')

    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-cegui.exe' \
        `$(TARGET)-pkg-config --cflags --libs CEGUI-0-OPENGL`
endef
