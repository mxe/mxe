# This file is part of MXE.
# See index.html for further information.

PKG             := arprec
$(PKG)_VERSION  := 2.2.17
$(PKG)_CHECKSUM := cb798d69cced5d198336b3826cc45ca1092167f2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://crd.lbl.gov/~dhbailey/mpdist/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libtool automake autoconf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://crd.lbl.gov/~dhbailey/mpdist/' | \
    $(SED) -n 's,.*<a href="http://crd.lbl.gov/~dhbailey/mpdist/arprec-\([0-9.]*\)[.]tar.*".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-shared \
        --enable-static \
        --enable-fortran=no
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
