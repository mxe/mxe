# This file is part of MXE.
# See index.html for further information.

PKG             := libgee
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.5.0
$(PKG)_CHECKSUM := aa6a2563867d3e3d56921bd1f7a7869d24599e1b5beb70e83f55b718fdddff51
$(PKG)_SUBDIR   := libgee-$($(PKG)_VERSION)
$(PKG)_FILE     := libgee-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgee/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libgee/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=LIBGEE_\\([0-9]*_[0-9]*_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef

$(PKG)_BUILD_SHARED =
