# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cunit
PKG             := cunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1-1
$(PKG)_CHECKSUM := a6aee7e346ba672c7723561f3e3253bfe53087ca
$(PKG)_SUBDIR   := CUnit-$($(PKG)_VERSION)
$(PKG)_FILE     := CUnit-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_WEBSITE  := http://cunit.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/cunit/CUnit/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/cunit/files/) | \
    $(SED) -n 's,.*CUnit-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
