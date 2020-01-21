# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := flex
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.0
$(PKG)_CHECKSUM := 24e611ef5a4703a191012f80c1027dc9d12555183ce0ecd46f3636e587e9b8e9
$(PKG)_SUBDIR   := flex-$($(PKG)_VERSION)
$(PKG)_FILE     := flex-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/flex/$($(PKG)_FILE)
$(PKG)_WEBSITE  := https://flex.sourceforge.io/
$(PKG)_OWNER    := https://github.com/tonytheodore
$(PKG)_TARGETS  := $(BUILD)
$(PKG)_DEPS     :=

REQUIREMENTS := $(filter-out $(PKG), $(REQUIREMENTS))

# recursive variable so always use literal instead of $(PKG)
MXE_REQS_PKGS   += $(BUILD)~flex

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/flex/files/' | \
    grep -i 'flex/files/' | \
    $(SED) -n 's,.*/flex-\([0-9\.]*\)\.tar.*/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD_$(BUILD)
    $(AUTOTOOLS_BUILD)
endef
