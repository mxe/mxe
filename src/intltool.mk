# This file is part of MXE.
# See index.html for further information.

PKG             := intltool
$(PKG)_VERSION  := 0.50.2
$(PKG)_CHECKSUM := 67f25c5c6fb71d095793a7f895b245e65e829e8bde68c6c8b4c912144ff34406
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://launchpad.net/intltool/trunk/$($(PKG)_VERSION)/+download/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://launchpad.net/intltool/+download' | \
    $(SED) -n 's,.*https://launchpad.net/intltool/trunk/\([0-9][^"]*\)\/+download/intltool-\([0-9][^"]*\)\.tar.*,\1,p' | \
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
