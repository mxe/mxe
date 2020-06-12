# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := gdb
$(PKG)_WEBSITE  := https://www.gnu.org/software/gdb/
$(PKG)_VERSION  := 9.2
$(PKG)_CHECKSUM := 360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32 expat libiconv mman-win32 readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --with-system-readline \
        --disable-gdbtk \
        --disable-tui \
        host_configargs="LIBS=\"`$(TARGET)-pkg-config --libs dlfcn` -lmman\"" \
        CONFIG_SHELL=$(SHELL) \
        LDFLAGS='-Wl,--allow-multiple-definition'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' MAKEINFO='/usr/bin/env true'

    # executables are always static and we don't want the rest
     $(INSTALL) -m755 '$(BUILD_DIR)/gdb/gdb.exe'                 '$(PREFIX)/$(TARGET)/bin/'
     $(INSTALL) -m755 '$(BUILD_DIR)/gdb/gdbserver/gdbserver.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
