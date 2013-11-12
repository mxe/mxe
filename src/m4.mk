# This file is part of MXE.
# See index.html for further information.

PKG             := m4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.17
$(PKG)_CHECKSUM := 74ad71fa100ec8c13bc715082757eb9ab1e4bbb0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/m4/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/m4/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="m4-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    # gets has been removed from recent glibc
    $(SED) -i -e '/gets is a/d' '$(1)/lib/stdio.in.h'
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
