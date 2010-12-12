# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FriBidi
PKG             := fribidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.2
$(PKG)_CHECKSUM := 3889469d96dbca3d8522231672e14cca77de4d5e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://fribidi.org/
$(PKG)_URL      := http://fribidi.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glib

define $(PKG)_UPDATE
    wget -q -O- 'http://fribidi.org/download/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="fribidi-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/lib/fribidi-common.h'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-debug \
        --disable-deprecated \
        --enable-charsets \
        --with-glib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= dist_man_MANS=
endef
