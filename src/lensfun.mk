# This file is part of MXE.
# See index.html for further information.

PKG             := lensfun
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f26121093dfee85d6371c2c79dae22e6d1b8d0d6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lensfun.berlios/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libpng glib

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        TKP='$(TARGET)-' \
        ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --sdkdir='$(PREFIX)/$(TARGET)' \
        --compiler=gcc \
        --target=windows.x86 \
        --mode=release \
        --vectorization= \
        --staticlibs=YES
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
