# This file is part of MXE.
# See index.html for further information.

PKG             := proj
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.1
$(PKG)_CHECKSUM := fca0388f3f8bc5a1a803d2f6ff30017532367992b30cf144f2d39be88f36c319
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
        $(MXE_CONFIGURE_OPTS) \
        --with-mutex
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    # remove header which is not installed since 4.8.0
    rm -f '$(PREFIX)/$(TARGET)'/include/projects.h
    $(MAKE) -C '$(1)' -j 1 install
endef

