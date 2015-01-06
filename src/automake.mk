# This file is part of MXE.
# See index.html for further information.

PKG             := automake
$(PKG)_IGNORE   := 1.14%
$(PKG)_VERSION  := 1.13.2
$(PKG)_CHECKSUM := 72ee9fcd180c54fd7c067155d85fa071a99c3ea3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/automake/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.gnu.org/pub/gnu/automake/$($(PKG)_FILE)
$(PKG)_DEPS     := autoconf

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/automake/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="automake-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' man1_MANS=
    $(MAKE) -C '$(1).build' -j 1 install man1_MANS=
endef
