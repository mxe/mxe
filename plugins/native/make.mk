# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := make
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1
$(PKG)_CHECKSUM := 0bc7613389650ee6a24554b52572a272f7356164fd2c4132b0bcf13123e4fca5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/make
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)

$(PKG)_DEPS_$(BUILD) := gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/make/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="make-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
