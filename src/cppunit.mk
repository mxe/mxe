# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cppunit
$(PKG)_WEBSITE  := https://www.freedesktop.org/wiki/Software/cppunit/
$(PKG)_DESCR    := CppUnit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.1
$(PKG)_CHECKSUM := 89c5c6665337f56fd2db36bc3805a5619709d51fb136e51937072f63fcc717a7
$(PKG)_SUBDIR   := cppunit-$($(PKG)_VERSION)
$(PKG)_FILE     := cppunit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dev-www.libreoffice.org/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://dev-www.libreoffice.org/src/' | \
    $(SED) -n 's,.*href="cppunit-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-doxygen \
        --disable-dot \
        --disable-html-docs \
        --disable-latex-docs
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef

$(PKG)_BUILD_SHARED =
