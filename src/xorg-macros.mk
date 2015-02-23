# This file is part of MXE.
# See index.html for further information.

PKG             := xorg-macros
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.0
$(PKG)_CHECKSUM := 00cfc636694000112924198e6b9e4d72f1601338
$(PKG)_SUBDIR   := util-macros-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://xorg.freedesktop.org/releases/individual/util/util-macros-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/xorg/util/macros/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=util-macros-\\([0-9.]*\\)'.*,\\1,p" | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install pkgconfigdir='$$(libdir)/pkgconfig'
endef
