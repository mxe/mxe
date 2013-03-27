# This file is part of MXE.
# See index.html for further information.

PKG             := binutils
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 042c51073205ebaf88c272d6168f9deb71984b56
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^2\.1' | \
    head -1
endef

define $(PKG)_BUILD
    # install config.guess for general use
    $(INSTALL) -d '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(1)/config.guess' '$(PREFIX)/bin/'

    # install target-specific autotools config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/share'
    echo "ac_cv_build=`$(1)/config.guess`" > '$(PREFIX)/$(TARGET)/share/config.site'

    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)' \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
