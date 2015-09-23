# This file is part of MXE.
# See index.html for further information.

PKG             := glfw3
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1
$(PKG)_CHECKSUM := 4948d5091d71a2249dc6d7e3effab2066089334844cea5cef0489b4a575b0bce
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
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DGLFW_BUILD_EXAMPLES=FALSE \
        -DGLFW_BUILD_TESTS=FALSE \
        -DGLFW_BUILD_DOCS=FALSE \
        -DGLFW_INSTALL_PKG_CONFIG=TRUE \
        -DGLFW_PKG_LIBS='-lopengl32 -lgdi32'
        $(MAKE) -C '$(1).build' -j '$(JOBS)' install

    # Windows convention: DLLs in bin/, not in lib/, import library is called "libglfw3.dll.a"
    $(if $(BUILD_SHARED),
        mv -fv $(PREFIX)/$(TARGET)/lib/glfw3.dll '$(PREFIX)/$(TARGET)/bin/'; \
        mv -fv $(PREFIX)/$(TARGET)/lib/glfw3dll.a '$(PREFIX)/$(TARGET)/lib/libglfw3.dll.a')

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-glfw3.exe' \
        `'$(TARGET)-pkg-config' glfw3 --cflags --libs`
endef

