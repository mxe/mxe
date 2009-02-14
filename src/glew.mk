# GLEW
# http://glew.sourceforge.net/

PKG            := glew
$(PKG)_VERSION := 1.5.1
$(PKG)_SUBDIR  := glew
$(PKG)_FILE    := glew-$($(PKG)_VERSION)-src.tgz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/glew/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=67586&package_id=67942' | \
    grep 'glew-' | \
    $(SED) -n 's,.*glew-\([1-9][^>]*\)-src\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-gcc -O2 -DGLEW_STATIC -Iinclude -c -o glew.o src/glew.c
    cd '$(1)' && $(TARGET)-ar cr libGLEW.a glew.o
    install -d '$(PREFIX)/$(TARGET)/lib'
    install -m644 '$(1)/libGLEW.a' '$(PREFIX)/$(TARGET)/lib/'
    install -d '$(PREFIX)/$(TARGET)/include'
    install -d '$(PREFIX)/$(TARGET)/include/GL'
    install -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(PREFIX)/$(TARGET)/include/GL/'
endef
