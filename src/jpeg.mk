# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jpeg
$(PKG)_WEBSITE  := http://www.ijg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9c
$(PKG)_CHECKSUM := 39e111cd9da5e72a589b98feeded334bb0e5776511e507e3d811ab25a213a3cd
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := jpegsrc.v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.ijg.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.ijg.org/' | \
    $(SED) -n 's,.*jpegsrc\.v\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: jpeg'; \
     echo 'Version: 0'; \
     echo 'Description: jpeg'; \
     echo 'Libs: -ljpeg';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/jpeg.pc'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-jpeg.exe' \
        `'$(TARGET)-pkg-config' jpeg --libs`
endef
