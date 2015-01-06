# This file is part of MXE.
# See index.html for further information.

PKG             := atk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.0
$(PKG)_CHECKSUM := 9b7f09a31f3781d5af4eb02ec0e2b289cf077a49
$(PKG)_SUBDIR   := atk-$($(PKG)_VERSION)
$(PKG)_FILE     := atk-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/atk/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib gettext

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/atk/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=ATK_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-glibtest \
        --disable-gtk-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= SHELL=bash
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
