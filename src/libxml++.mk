# This file is part of MXE.
# See index.html for further information.

PKG             := libxml++
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.37.2
$(PKG)_CHECKSUM := bb3e10a2148e90fc61098499a0923b4de786b1dd86466d7ec6255e154baa773b
$(PKG)_SUBDIR   := libxml++-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libxml++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc glibmm libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libxml++/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CXX="$(TARGET)-g++ -mthreads" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
