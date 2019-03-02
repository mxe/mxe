# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := glfw3
$(PKG)_WEBSITE  := https://www.glfw.org/
$(PKG)_DESCR    := GLFW 3.x
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := e10f0de1384d75e6fc210c53e91843f6110d6c4f3afbfb588130713c2f9d8fe8
$(PKG)_GH_CONF  := glfw/glfw/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        -DGLFW_BUILD_EXAMPLES=FALSE \
        -DGLFW_BUILD_TESTS=FALSE \
        -DGLFW_BUILD_DOCS=FALSE \
        -DGLFW_INSTALL_PKG_CONFIG=TRUE \
        -DGLFW_PKG_LIBS='-lopengl32 -lgdi32' \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # Windows convention: DLLs in bin/, not in lib/, import library is called "libglfw3.dll.a"
    $(if $(BUILD_SHARED),
        mv -fv $(PREFIX)/$(TARGET)/lib/glfw3.dll '$(PREFIX)/$(TARGET)/bin/'; \
        mv -fv $(PREFIX)/$(TARGET)/lib/*glfw3dll.a '$(PREFIX)/$(TARGET)/lib/libglfw3.dll.a')

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-glfw3.exe' \
        `'$(TARGET)-pkg-config' glfw3 --cflags --libs`
endef
