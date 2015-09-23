# This file is part of MXE.
# See index.html for further information.

PKG             := libodbc++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.5
$(PKG)_CHECKSUM := ba3030a27b34e4aafbececa2ddbbf42a38815e9534f34c051620540531b5e23e
$(PKG)_SUBDIR   := libodbc++-$($(PKG)_VERSION)
$(PKG)_FILE     := libodbc++-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libodbcxx/libodbc++/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/libodbcxx/files/libodbc%2B%2B" | \
    grep 'libodbcxx/files/libodbc%2B%2B/' | \
    $(SED) -n 's,.*/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    touch '$(1)/aclocal.m4'
    touch '$(1)/Makefile.in'
    touch '$(1)/config.h.in'
    cd '$(1)' && ./configure \
      --prefix='$(PREFIX)/$(TARGET)' \
      --host='$(TARGET)' \
      --disable-shared \
      --without-tests \
      --disable-dependency-tracking
    $(MAKE) -C '$(1)' -j '$(JOBS)' install doxygen= progref_dist_files=
endef

$(PKG)_BUILD_SHARED =
