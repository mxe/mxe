# This file is part of MXE.
# See index.html for further information.

PKG             := libjpeg-turbo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.1
$(PKG)_CHECKSUM := 4bf5bad4ce85625bffbbd9912211e06790e00fb982b77724af7211034efafb08
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/$(PKG)/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --libdir='$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        --includedir='$(PREFIX)/$(TARGET)/include/$(PKG)' \
        NASM=$(TARGET)-yasm
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: jpeg-turbo'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: jpeg-turbo'; \
     echo 'Cflags: -I$(PREFIX)/$(TARGET)/include/$(PKG)'; \
     echo 'Libs: -L$(PREFIX)/$(TARGET)/lib/$(PKG) -ljpeg';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/jpeg-turbo.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TOP_DIR)/src/jpeg-test.c' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' jpeg-turbo --cflags --libs`
endef
