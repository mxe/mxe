# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsigc++
$(PKG)_WEBSITE  := https://libsigc.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.99.9
$(PKG)_CHECKSUM := 7628072c0afe5e3d7375877356c6009a9e4933800c1728424b1f2853aa35571c
$(PKG)_SUBDIR   := libsigc++-$($(PKG)_VERSION)
$(PKG)_FILE     := libsigc++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libsigc++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
     $(WGET) -q -O- 'https://github.com/GNOME/libsigcplusplus/releases' | \
     $(SED) -n '/<a href=.*archive/ s,.*archive/\([0-9.]*\).tar.gz.*,\1,p' | \
     head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CXX='$(TARGET)-g++' \
        PKG_CONFIG='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)
endef
