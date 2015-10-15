# This file is part of MXE.
# See index.html for further information.

PKG             := lcms1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.19
$(PKG)_CHECKSUM := 80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9
$(PKG)_SUBDIR   := lcms-$($(PKG)_VERSION)
$(PKG)_FILE     := lcms-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/lcms/lcms/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lcms/files/lcms/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep '^1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
