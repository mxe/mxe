# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# ZZIPlib
PKG             := zziplib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.58
$(PKG)_CHECKSUM := 4255290de3b66deb4a7233ab41727c1b56739e8c
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
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
