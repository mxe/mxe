# This file is part of MXE.
# See index.html for further information.

PKG             := speex
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 52daa72572e844e5165315e208da539b2a55c5eb
$(PKG)_SUBDIR   := speex-$($(PKG)_VERSION)
$(PKG)_FILE     := speex-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/speex/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.xiph.org/?p=speex.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>Speex-\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-oggtest
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= doc_DATA=
endef
