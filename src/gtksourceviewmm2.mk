# This file is part of MXE.
# See index.html for further information.

PKG             := gtksourceviewmm2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7f6fb046427054d85c791a4b1fc0f742a3313c8a
$(PKG)_SUBDIR   := gtksourceviewmm-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtksourceviewmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gtkmm2 gtksourceview

define $(PKG)_UPDATE
    wget -q -O- 'http://git.gnome.org/cgit/gtksourceviewmm/refs/tags' | \
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
        $(LINK_STYLE) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl'
endef

$(PKG)_BUILD_i686-static-mingw32    = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32  =
$(PKG)_BUILD_i686-dynamic-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-dynamic-mingw32 = $($(PKG)_BUILD)
