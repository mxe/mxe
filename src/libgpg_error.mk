# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libgpg-error
PKG             := libgpg_error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.10
$(PKG)_CHECKSUM := 95b324359627fbcb762487ab6091afbe59823b29
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := ftp://ftp.gnupg.org/gcrypt/libgpg-error/
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-languages
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
