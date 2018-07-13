# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glfw2
$(PKG)_WEBSITE  := https://www.glfw.org/
$(PKG)_DESCR    := GLFW 2.x
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.9
$(PKG)_CHECKSUM := b7276dcadc85a07077834d1043f11ffd6a3a379647bb94361b4abc3ffca75e7d
$(PKG)_SUBDIR   := glfw-$($(PKG)_VERSION)
$(PKG)_FILE     := glfw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/glfw/glfw/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/glfw/files/glfw/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep '^2\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/lib/win32' && $(MAKE) -f Makefile.win32.cross-mgw \
        TARGET=$(TARGET)- \
        PREFIX='$(PREFIX)/$(TARGET)' \
        $(if $(BUILD_STATIC),libglfw.a,glfw.dll) libglfw.pc -j '$(JOBS)'

    # Install manually to split static and shared
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(if $(BUILD_STATIC), \
        $(INSTALL) -c -m 644 '$(1)/lib/win32/libglfw.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/libglfw.pc'
        $(INSTALL) -c -m 644 '$(1)/lib/win32/libglfw.a' '$(PREFIX)/$(TARGET)/lib/libglfw.a', \
        $(SED) -e "s|Cflags:|Cflags: -DGLFW_DLL|g" '$(1)/lib/win32/libglfw.pc' > \
            '$(PREFIX)/$(TARGET)/lib/pkgconfig/libglfw.pc'; \
        $(INSTALL) -c '$(1)/lib/win32/glfw.dll' '$(PREFIX)/$(TARGET)/bin/glfw.dll'; \
        $(INSTALL) -c '$(1)/lib/win32/libglfwdll.a' '$(PREFIX)/$(TARGET)/lib/libglfw.dll.a')
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/GL'
    $(INSTALL) -c -m 644 $(1)/include/GL/glfw.h '$(PREFIX)/$(TARGET)/include/GL/glfw.h'



    #Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-glfw2.exe' \
        `'$(TARGET)-pkg-config' libglfw --cflags --libs`
endef

