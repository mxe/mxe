# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := m4
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.18
$(PKG)_CHECKSUM := f2c1e86ca0a404ff281631bdc8377638992744b175afb806e25871a24a934e07
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/m4/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/m4/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/m4
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/m4/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="m4-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    # gets has been removed from recent glibc
    $(SED) -i -e '/gets is a/d' '$(SOURCE_DIR)/lib/stdio.in.h'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
