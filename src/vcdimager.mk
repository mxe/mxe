# This file is part of MXE.
# See index.html for further information.

PKG             := vcdimager
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.24
$(PKG)_CHECKSUM := 075d7a67353ff3004745da781435698b6bc4a053838d0d4a3ce0516d7d974694
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/vcdimager/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libcdio libxml2 popt

define $(PKG)_UPDATE
    echo 'TODO: Updates for package vcdimager need to be written.' >&2;
    echo $(vcdimager_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install
endef
