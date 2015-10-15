# This file is part of MXE.
# See index.html for further information.

PKG             := lensfun
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.0
$(PKG)_CHECKSUM := c2c3c03873cb549d49d42f118fcb0ffa95d1e45b9ff395e19facb63bf699bec1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lensfun/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib libgnurx libpng

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lensfun/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/building'
    cd '$(1)/building' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_STATIC=$(if $(BUILD_STATIC),TRUE,FALSE) \
        -DINSTALL_IN_TREE=NO
    $(MAKE) -C '$(1)/building' -j '$(JOBS)' install VERBOSE=1

    # Don't use `-ansi`, as lensfun uses C++-style `//` comments.
    '$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-lensfun.exe' \
        `'$(TARGET)-pkg-config' lensfun glib-2.0 --cflags --libs`
endef
