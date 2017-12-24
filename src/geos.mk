# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := geos
$(PKG)_WEBSITE  := https://trac.osgeo.org/geos/
$(PKG)_DESCR    := GEOS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.2
$(PKG)_CHECKSUM := 045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a
$(PKG)_SUBDIR   := geos-$($(PKG)_VERSION)
$(PKG)_FILE     := geos-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.osgeo.org/geos/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/geos/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://download.osgeo.org/geos/' | \
    $(SED) -n 's,.*geos-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(1)' -j 1 $(INSTALL_STRIP_LIB)

    ln -sf '$(PREFIX)/$(TARGET)/bin/geos-config' '$(PREFIX)/bin/$(TARGET)-geos-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-geos.exe' \
        `'$(PREFIX)/bin/$(TARGET)-geos-config' --cflags --clibs`
endef
