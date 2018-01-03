# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libxml++
$(PKG)_WEBSITE  := https://libxmlplusplus.sourceforge.io/
$(PKG)_DESCR    := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.40.1
$(PKG)_CHECKSUM := 4ad4abdd3258874f61c2e2a41d08e9930677976d303653cd1670d3e9f35463e9
$(PKG)_SUBDIR   := libxml++-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.gnome.org/sources/libxml++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc glibmm libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.gnome.org/browse/libxml++/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CXX="$(TARGET)-g++ -mthreads" ./configure \
        $(MXE_CONFIGURE_OPTS) \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
