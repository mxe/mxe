# This file is part of MXE.
# See index.html for further information.

PKG             := proj
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.0
$(PKG)_CHECKSUM := 5c8d6769a791c390c873fef92134bf20bb20e82a
$(PKG)_SUBDIR   := proj-$($(PKG)_VERSION)
$(PKG)_FILE     := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/proj/' | \
    $(SED) -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-mutex
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    # remove header which is not installed since 4.8.0
    rm -f '$(PREFIX)/$(TARGET)'/include/projects.h
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
