# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ATKmm
PKG             := atkmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.21.2
$(PKG)_CHECKSUM := 5aa7ef7733bd614e5ef922d300a2559c59a5d9dc
$(PKG)_SUBDIR   := atkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := atkmm-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.gtk.org/
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/atkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := atk glibmm

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/browse/atkmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=ATKMM_\\([0-9]*_[0-9]*[02468]_[^<]*\\)'.*,\\1,p" | \
    $(SED) 's,_,.,g' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
	     MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
