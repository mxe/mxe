# This file is part of MXE.
# See index.html for further information.

PKG             := gtksourceviewmm2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10.3
$(PKG)_CHECKSUM := 17d5daf33d2b6bc21c48c5c730abaae70e027566
$(PKG)_SUBDIR   := gtksourceviewmm-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceviewmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtkmm2 gtksourceview

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/cgit/gtksourceviewmm/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=gtksourceviewmm-\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^2\.9[0-9]\.' | \
    grep '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl'
endef

$(PKG)_BUILD_SHARED =
