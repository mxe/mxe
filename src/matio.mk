# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := matio
$(PKG)_WEBSITE  := https://sourceforge.net/projects/matio/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.23
$(PKG)_CHECKSUM := 9f91eae661df46ea53c311a1b2dcff72051095b023c612d7cbfc09406c9f4d6e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc hdf5 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/matio/files/matio/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        # work-around for AC test that cannot be run in crosscompile mode
        # https://github.com/tbeu/matio/issues/78
        ac_cv_va_copy=C99
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_SHARED =
