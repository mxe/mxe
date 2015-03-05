# This file is part of MXE.
# See index.html for further information.

PKG             := libcdio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.93
$(PKG)_CHECKSUM := ac6ef86c578a7c2a601456139b288443a4f289f5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/gnu/libcdio/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libcdio need to be written.' >&2;
    echo $(libcdio_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
