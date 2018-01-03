# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jpeg
$(PKG)_WEBSITE  := http://www.ijg.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9b
$(PKG)_CHECKSUM := 240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052
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
