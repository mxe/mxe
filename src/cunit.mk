# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# cunit
PKG             := cunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1-0
$(PKG)_CHECKSUM := 05920c1defda3527cee3bc82fb9eadf45c5ea7a1
$(PKG)_SUBDIR   := CUnit-$($(PKG)_VERSION)
$(PKG)_FILE     := CUnit-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_WEBSITE  := http://cunit.sourceforge.net
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/cunit/CUnit/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/cunit/files/cunit/) | \
    $(SED) -n 's,.*CUnit-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
