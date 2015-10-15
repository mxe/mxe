# This file is part of MXE.
# See index.html for further information.

PKG             := fribidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.6
$(PKG)_CHECKSUM := cba8b7423c817e5adf50d28ec9079d14eafcec9127b9e8c8f1960c5ad585e17d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://fribidi.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://fribidi.org/download/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="fribidi-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC),\
        $(SED) -i 's/__declspec(dllimport)//' '$(1)/lib/fribidi-common.h')
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-debug \
        --disable-deprecated \
        --enable-charsets \
        --with-glib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= dist_man_MANS=
endef
