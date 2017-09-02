# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libjpeg-turbo
$(PKG)_WEBSITE  := http://libjpeg-turbo.virtualgl.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 9098943b270388727ae61de82adec73cf9f0dbb240b3bc8b172595ebf405b528
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/$(PKG)/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --libdir='$(PREFIX)/$(TARGET)/lib/$(PKG)' \
        --includedir='$(PREFIX)/$(TARGET)/include/$(PKG)' \
        NASM=$(TARGET)-yasm
    $(MAKE) -C '$(1)' -j '$(JOBS)' || $(MAKE) -C '$(1)' -j 1
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_CRUFT)

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
