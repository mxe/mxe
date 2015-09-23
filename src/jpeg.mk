# This file is part of MXE.
# See index.html for further information.

PKG             := jpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9a
$(PKG)_CHECKSUM := 3a753ea48d917945dd54a2d97de388aa06ca2eb1066cbfdc6652036349fe05a7
$(PKG)_SUBDIR   := jpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := jpegsrc.v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.ijg.org/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

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
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-jpeg.exe' \
        `'$(TARGET)-pkg-config' jpeg --libs`
endef
