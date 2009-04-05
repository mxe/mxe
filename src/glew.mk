# GLEW

PKG             := glew
$(PKG)_VERSION  := 1.5.1
$(PKG)_CHECKSUM := a94113169d46487ccda1bb2fde68fa1803bdf009
$(PKG)_SUBDIR   := glew
$(PKG)_FILE     := glew-$($(PKG)_VERSION)-src.tgz
$(PKG)_WEBSITE  := http://glew.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/glew/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=67586&package_id=67942' | \
    grep 'glew-' | \
    $(SED) -n 's,.*glew-\([0-9][^>]*\)-src\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-gcc -O2 -DGLEW_STATIC -Iinclude -c -o glew.o src/glew.c
    cd '$(1)' && $(TARGET)-ar cr libGLEW.a glew.o
    $(TARGET)-ranlib '$(1)/libGLEW.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/libglew32s.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'
endef
