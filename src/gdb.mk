# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdb
$(PKG)_WEBSITE  := https://www.gnu.org/software/gdb/
$(PKG)_VERSION  := 11.2
$(PKG)_CHECKSUM := 1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 expat gmp libiconv mman-win32 readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --enable-static \
        --disable-shared \
        --disable-source-highlight \
        --with-system-readline \
        --disable-gdbtk \
        --disable-tui \
        host_configargs="LIBS=\"`$(TARGET)-pkg-config --libs dlfcn` -lmman\"" \
        CONFIG_SHELL=$(SHELL) \
        LDFLAGS='-Wl,--allow-multiple-definition'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' MAKEINFO='/usr/bin/env true'

    # executables are always static and we don't want the rest
     $(INSTALL) -m755 '$(BUILD_DIR)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
     $(INSTALL) -m755 '$(BUILD_DIR)/gdbserver/gdbserver.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
