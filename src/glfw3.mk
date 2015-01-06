# This file is part of MXE.
# See index.html for further information.

PKG             := glfw3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.3
$(PKG)_CHECKSUM := 95d0d2a250dc4e9d612cdd1a7433de464db16d89
$(PKG)_SUBDIR   := glfw-$($(PKG)_VERSION)
$(PKG)_FILE     := glfw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glfw/glfw/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/glfw/files/glfw/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep '^3\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && cmake '$(1)' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DGLFW_BUILD_EXAMPLES=FALSE \
        -DGLFW_BUILD_TESTS=FALSE \
        -DGLFW_INSTALL_PKG_CONFIG=TRUE \
        -DGLFW_PKG_LIBS='-lopengl32 -lgdi32'
        $(MAKE) -C '$(1).build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glfw3.exe' \
        `'$(TARGET)-pkg-config' glfw3 --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
