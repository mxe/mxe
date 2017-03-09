# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libomemo
$(PKG)_WEBSITE  := https://github.com/gkdr/libomemo
$(PKG)_DESCR    := Implementation of OMEMO in C
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.1
$(PKG)_CHECKSUM := af66fd2958dc5d6b23bc488b69e9f431bfb308d79bdd1b1c31de4575862c5142
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/gkdr/libomemo/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc glib libgcrypt mxml sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/gkdr/libomemo/releases' | \
    $(SED) -n 's,.*/gkdr/libomemo/archive/v\([0-9\.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' all \
        CC='$(TARGET)-gcc' \
        LD='$(TARGET)-ld' \
        AR='$(TARGET)-ar' \
        PKG_CONFIG='$(TARGET)-pkg-config' \
        LIBGCRYPT_CONFIG='$(PREFIX)/$(TARGET)/bin/libgcrypt-config'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/build'/libomemo*.a  '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/src'/libomemo*.h  '$(PREFIX)/$(TARGET)/include/'
endef

$(PKG)_BUILD_SHARED =
