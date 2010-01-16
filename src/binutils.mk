# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# GNU Binutils
PKG             := binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.20
$(PKG)_CHECKSUM := 747e7b4d94bce46587236dc5f428e5b412a590dc
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/binutils/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceware.org/cgi-bin/cvsweb.cgi/src/binutils/?cvsroot=src' | \
    grep '<OPTION>binutils-' | \
    $(SED) -n 's,.*binutils-\([0-9][0-9_]*\).*,\1,p' | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
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
