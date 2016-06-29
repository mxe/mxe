# This file is part of MXE.
# See index.html for further information.

PKG             := freeglut
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := 2a43be8515b01ea82bcfa17d29ae0d40bd128342f0930cd1f375f1ff999f76a2
$(PKG)_SUBDIR   := freeglut-$($(PKG)_VERSION)
$(PKG)_FILE     := freeglut-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeglut/freeglut/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeglut/files/freeglut/' | \
    $(SED) -n 's,.*freeglut-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && $(TARGET)-cmake '$(1)' \
        -DFREEGLUT_GLES=OFF \
        -DFREEGLUT_BUILD_DEMOS=OFF \
        -DFREEGLUT_REPLACE_GLUT=ON \
        -DFREEGLUT_BUILD_STATIC_LIBS=$(if $(BUILD_STATIC),true,false) \
        -DFREEGLUT_BUILD_SHARED_LIBS=$(if $(BUILD_STATIC),false,true)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-freeglut.exe' \
        $(if $(BUILD_STATIC),-DFREEGLUT_STATIC) \
        -L'$(PREFIX)/$(TARGET)/lib' -lglut -lglu32 -lopengl32 -lgdi32 -lwinmm
endef
