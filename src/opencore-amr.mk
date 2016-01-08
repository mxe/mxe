# This file is part of MXE.
# See index.html for further information.

PKG             := opencore-amr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.3
$(PKG)_CHECKSUM := 106bf811c1f36444d7671d8fd2589f8b2e0cca58a2c764da62ffc4a070595385
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/opencore-amr/files/opencore-amr/' | \
    $(SED) -n 's,.*opencore-amr-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
