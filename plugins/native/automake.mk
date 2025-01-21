# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := automake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.17
$(PKG)_CHECKSUM := 397767d4db3018dd4440825b60c64258b636eaf6bf99ac8b0897f06c89310acd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/automake/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/automake/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/automake
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := autoconf

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/automake/?C=M;O=D' | \
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
