# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FreeImage
PKG             := freeimage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.15.1
$(PKG)_CHECKSUM := 02ae98007fc64d72a8f15ec3ff24c36ac745fbc8
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_WEBSITE  := http://freeimage.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/freeimage/files/Source Distribution/' | \
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
