# This file is part of MXE.
# See index.html for further information.

PKG             := binutils
# see http://lists.nongnu.org/archive/html/mingw-cross-env-list/2016-01/msg00013.html
# 2.26 causes incorrect dlls to be built with sjlj exceptions
$(PKG)_IGNORE   := 2.26
$(PKG)_VERSION  := 2.25.1
$(PKG)_CHECKSUM := b5b14added7d78a8d1ca70b5cb75fef57ce2197264f4f5835326b0df22ac9f22
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     := pkgconf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --build='$(BUILD)' \
        --prefix='$(PREFIX)' \
        --disable-multilib \
        --enable-deterministic-archives \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        --disable-shared \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    rm -f $(addprefix $(PREFIX)/$(TARGET)/bin/, ar as dlltool ld ld.bfd nm objcopy objdump ranlib strip)
endef

$(PKG)_BUILD_$(BUILD) :=
