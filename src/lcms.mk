# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := lcms
$(PKG)_WEBSITE  := http://www.littlecms.com/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.16
$(PKG)_CHECKSUM := d873d34ad8b9b4cea010631f1a6228d2087475e4dc5e763eb81acc23d9d45a51
$(PKG)_SUBDIR   := $(PKG)$(word 1,$(subst ., ,$($(PKG)_VERSION)))-$(subst a,,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)$(word 1,$(subst ., ,$($(PKG)_VERSION)))-$(subst a,,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(subst a,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/lcms/files/lcms/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
