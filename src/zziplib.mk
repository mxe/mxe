# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# ZZIPlib
PKG             := zziplib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.59
$(PKG)_CHECKSUM := ddbce25cb36c3b4c2b892e2c8a88fa4a0be29a71
$(PKG)_SUBDIR   := zziplib-$($(PKG)_VERSION)
$(PKG)_FILE     := zziplib-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://zziplib.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/zziplib/zziplib$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/zziplib/files/) | \
    $(SED) -n 's,.*zziplib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-mmap \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
