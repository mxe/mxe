# This file is part of MXE.
# See index.html for further information.

PKG             := cppunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.2
$(PKG)_CHECKSUM := 0eaf8bb1dcf4d16b12bec30d0732370390d35e6f
$(PKG)_SUBDIR   := cppunit-$($(PKG)_VERSION)
$(PKG)_FILE     := cppunit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://dev-www.libreoffice.org/src/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/cppunit/files/cppunit/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
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
