# This file is part of MXE.
# See index.html for further information.

PKG             := geos
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.2
$(PKG)_CHECKSUM := 15e8bfdf7e29087a957b56ac543ea9a80321481cef4d4f63a7b268953ad26c53
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://geos.refractions.net/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    ln -sf '$(PREFIX)/$(TARGET)/bin/geos-config' '$(PREFIX)/bin/$(TARGET)-geos-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-geos.exe' \
        `'$(PREFIX)/bin/$(TARGET)-geos-config' --cflags --clibs`
endef
