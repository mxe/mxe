# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.2
$(PKG)_CHECKSUM := f048d1838da284c8bc9753e4506b85a1e0cc1ea8999d36f6995bcb9460cddbd7
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/sed
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)

$(PKG)_DEPS_$(BUILD) := gettext libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/sed/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="sed-\([0-9][^"]*\)\.tar.*,\1,p' | \
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
