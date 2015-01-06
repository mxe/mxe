# This file is part of MXE.
# See index.html for further information.

PKG             := glfw2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.9
$(PKG)_CHECKSUM := b189922e9804062a0014a3799b4dc35431034623
$(PKG)_SUBDIR   := glfw-$($(PKG)_VERSION)
$(PKG)_FILE     := glfw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glfw/glfw/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/glfw/files/glfw/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep '^2\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/lib/win32' && $(MAKE) -f Makefile.win32.cross-mgw \
        TARGET=$(TARGET)- \
        PREFIX='$(PREFIX)/$(TARGET)' \
        install -j '$(JOBS)'

    #Test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glfw2.exe' \
        `'$(TARGET)-pkg-config' libglfw --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
