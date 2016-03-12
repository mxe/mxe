# This file is part of MXE.
# See index.html for further information.

PKG             := gdb
$(PKG)_VERSION  := 7.11
$(PKG)_CHECKSUM := 7a434116cb630d77bb40776e8f5d3937bed11dea56bafebb4d2bc5dd389fe5c1
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc expat libiconv readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-system-readline \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    # executables are always static and we don't the rest
     $(INSTALL) -m755 '$(1)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
     $(INSTALL) -m755 '$(1)/gdb/gdbserver/gdbserver.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
