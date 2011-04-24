# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Libidn
PKG             := libidn
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.21
$(PKG)_CHECKSUM := 991d5d4e24118d7672d53ed692a8a6ab87212f8f
$(PKG)_SUBDIR   := libidn-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/libidn/
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    wget -q -O- 'http://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) -i 's,cross_compiling=no,cross_compiling=yes,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-csharp \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-libiconv-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
