# This file is part of MXE.
# See index.html for further information.

PKG             := xorg-macros
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19.0
$(PKG)_CHECKSUM := 2835b11829ee634e19fa56517b4cfc52ef39acea0cd82e15f68096e27cbed0ba
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
