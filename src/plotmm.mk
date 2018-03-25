# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := plotmm
$(PKG)_WEBSITE  := https://plotmm.sourceforge.io/
$(PKG)_DESCR    := PlotMM
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.2
$(PKG)_CHECKSUM := 896bb729eb9cad5f3188d72304789dd7a86fdae66020ac0632fe3bc66abe9653
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gtkmm2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/plotmm/files/plotmm/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=
endef

$(PKG)_BUILD_SHARED =
