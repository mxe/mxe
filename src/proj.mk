# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# proj
PKG             := proj
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.0
$(PKG)_CHECKSUM := bfe59b8dc1ea0c57e1426c37ff2b238fea66acd7
$(PKG)_SUBDIR   := proj-$($(PKG)_VERSION)
$(PKG)_FILE     := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://trac.osgeo.org/proj/
$(PKG)_URL      := http://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2    := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://trac.osgeo.org/proj/' | \
    $(SED) -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-mutex
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
