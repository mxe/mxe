# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := bison
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.4
$(PKG)_CHECKSUM := a72428c7917bdf9fa93cb8181c971b6e22834125848cf1d03ce10b1bb0716fe1
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://ftp.gnu.org/gnu/bison/$($(PKG)_FILE)
$(PKG)_URL_2    := https://ftpmirror.gnu.org/bison/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://www.gnu.org/software/bison
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     := flex

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

# recursive variable so always use literal instead of $(PKG)
MXE_REQS_PKGS   += $(BUILD)~bison

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/bison/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="bison-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    $(AUTOTOOLS_BUILD)
endef
