# This file is part of MXE.
# See index.html for further information.

PKG             := vcdimager
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.24
$(PKG)_CHECKSUM := 8c245555c3e21dcbc3d4dbb2ecca74f609545424
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/vcdimager/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc popt libxml2

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j 1 install
endef
