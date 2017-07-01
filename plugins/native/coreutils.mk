# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := coreutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.23
$(PKG)_CHECKSUM := ec43ca5bcfc62242accb46b7f121f6b684ee21ecd7d075059bf650ff9e37b82d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/coreutils
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)

$(PKG)_DEPS_$(BUILD) := gettext gmp libiconv libtool

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/coreutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="coreutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
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
