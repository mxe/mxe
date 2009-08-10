# GCC core

PKG             := gcc-core
$(PKG)_VERSION  := 4.4.0
$(PKG)_CHECKSUM := 081c5a1e49157b9c48fe97497633b6ff39032eb5
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-core-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://gcc.gnu.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/tdm-gcc/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/tdm-gcc/files/Sources/) | \
    $(SED) -n 's,.*gcc-core-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef
