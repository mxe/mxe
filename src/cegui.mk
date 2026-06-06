# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cegui
$(PKG)_WEBSITE  := http://cegui.org.uk/
$(PKG)_DESCR    := Crazy Eddie’s GUI System (CEGUI)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.7
$(PKG)_CHECKSUM := 7be289d2d8562e7d20bd155d087d6ccb0ba62f7e99cc25d20684b8edf2ba15cd
$(PKG)_SUBDIR   := $(PKG)-$(subst .,-,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/cegui/cegui/archive/refs/tags/v$(subst .,-,$($(PKG)_VERSION)).tar.gz
$(PKG)_DEPS     := cc expat freeglut freeimage freetype fribidi glew \
                   glfw3 glm libxml2 minizip pcre xerces

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/cegui/cegui/git/refs/tags/' | \
    $(SED) -n 's,.*"refs/tags/v0-8-\([0-9]*\)".*,\1,p' | \
    $(SORT) -V | \
    tail -1 | \
    awk '{print "0.8."$$1}'
endef

# Use pkg-config to set FREEIMAGE_LIB and GLEW_STATIC to prevent "_imp__" errors
# freeimage and xerces don't have shared builds - disable with $(CMAKE_STATIC_BOOL)
# devil appears to be dead, tinyxml is deprecated, lua needs toluapp
# boost and sdl2 aren't detected
define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
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
        -DCMAKE_CXX_FLAGS="`$(TARGET)-pkg-config --cflags glew freeimage freetype2 libpcre`" \
        -DFREETYPE_H_PATH_ft2build='$(PREFIX)/$(TARGET)/include/freetype2' \
        -DFREETYPE_H_PATH_ftconfig='$(PREFIX)/$(TARGET)/include/freetype2' \
        -DFREETYPE_INCLUDE_DIR='$(PREFIX)/$(TARGET)/include/freetype2' \
        '$(SOURCE_DIR)'

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
