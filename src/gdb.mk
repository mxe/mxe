# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# gdb
PKG             := gdb
$(PKG)_VERSION  := 7.3.1
$(PKG)_CHECKSUM := e57f2c7f93536ef54fab728eb733bf2c36550718
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gnu.org/software/gdb/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat libiconv zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^7\.3a' | \
    sort -r | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
