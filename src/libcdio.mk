# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libcdio
$(PKG)_WEBSITE  := https://www.gnu.org/software/libcdio/
$(PKG)_DESCR    := Libcdio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.93
$(PKG)_CHECKSUM := f8276629226c7e1e74209b66ca421d09d6aec87f72f60ae9b1d3debd0a13dda8
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://ftp.gnu.org/gnu/libcdio/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libcdio need to be written.' >&2;
    echo $(libcdio_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
