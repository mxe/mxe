# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jpeg
$(PKG)_WEBSITE  := https://www.ijg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9d
$(PKG)_CHECKSUM := 99cb50e48a4556bc571dadd27931955ff458aae32f68c4d9c39d624693f69c32
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := jpegsrc.v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.ijg.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.ijg.org/' | \
    $(SED) -n 's,.*jpegsrc\.v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-jpeg.exe' \
        `'$(TARGET)-pkg-config' libjpeg --libs`
endef
