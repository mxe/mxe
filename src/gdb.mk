# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gdb
PKG             := gdb
$(PKG)_VERSION  := 7.2
$(PKG)_CHECKSUM := 14daf8ccf1307f148f80c8db17f8e43f545c2691
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION)a.tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/gdb/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat libiconv zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/gdb' -j 1 install
endef
