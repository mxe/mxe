# This file is part of MXE.
# See index.html for further information.

PKG             := pfstools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.5
$(PKG)_CHECKSUM := dc595438f0fd8b40a05d9f9c498892363a1b3f05
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/pfstools/files/pfstools/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-netpbm \
        --disable-openexr \
        --disable-tiff \
        --disable-qt \
        --disable-jpeghdr \
        --disable-imagemagick \
        --disable-octave \
        --disable-opengl \
        --disable-matlab \
        --disable-gdal
    $(MAKE) -C '$(1)'/src/pfs -j '$(JOBS)'
    $(MAKE) -C '$(1)'/src/pfs -j 1 install
endef

$(PKG)_BUILD_SHARED =
