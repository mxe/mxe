# This file is part of MXE.
# See index.html for further information.

PKG             := djvulibre
$(PKG)_VERSION  := 3.5.27
$(PKG)_CHECKSUM := e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/djvu/DjVuLibre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/djvu/files/DjVuLibre/' | \
    $(SED) -n 's,.*/\([0-9][^A-Za-z"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)' && automake
    cd '$(1)' && ./configure $(MXE_CONFIGURE_OPTS) --disable-desktopfiles
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-strip

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' ddjvuapi --cflags --libs`
endef
