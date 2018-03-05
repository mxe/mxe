# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cppunit
$(PKG)_WEBSITE  := https://www.freedesktop.org/wiki/Software/cppunit/
$(PKG)_DESCR    := CppUnit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.2
$(PKG)_CHECKSUM := 3f47d246e3346f2ba4d7c9e882db3ad9ebd3fcbd2e8b732f946e0e3eeb9f429f
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
