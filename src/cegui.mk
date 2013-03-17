# This file is part of MXE.
# See index.html for further information.

PKG             := cegui
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f0a8616bcb37843ad2f83c88745b9313906cb8e9
$(PKG)_SUBDIR   := CEGUI-$($(PKG)_VERSION)
$(PKG)_FILE     := CEGUI-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/crayzedsgui/CEGUI%20Mk-2/$($(PKG)_VERSION)/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gcc freeglut freeimage freetype pcre xerces libxml2 expat

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-freetype \
        --enable-pcre \
        --enable-xerces \
        --enable-libxml2 \
        --enable-expat \
        --disable-corona \
        --disable-devil \
        --enable-freeimage \
        --disable-silly \
        --enable-tga \
        --enable-stb \
        --enable-opengl-renderer \
        --disable-ogre-renderer \
        --disable-irrlicht-renderer \
        --disable-directfb-renderer \
        --enable-samples \
        --disable-lua-module \
        --disable-python-module \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef
