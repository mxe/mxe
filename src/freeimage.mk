# This file is part of MXE.
# See index.html for further information.

PKG             := freeimage
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1d30057a127b2016cf9b4f0f8f2ba92547670f96
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeimage/files/Source Distribution/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,install ,$(INSTALL) ,' '$(1)'/Makefile.gnu

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        INCDIR='$(PREFIX)/$(TARGET)/include' \
        INSTALLDIR='$(PREFIX)/$(TARGET)/lib'

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu install \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        INCDIR='$(PREFIX)/$(TARGET)/include' \
        INSTALLDIR='$(PREFIX)/$(TARGET)/lib'
endef
