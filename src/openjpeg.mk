# This file is part of MXE.
# See index.html for further information.

PKG             := openjpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := b2f917acd01b6e6fdc397cf5ef0c0e50e2ab7d19
$(PKG)_SUBDIR   := openjpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/openjpeg.mirror/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tiff libpng zlib lcms

#git commit 3d95bcf
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/openjpeg.mirror/files/2.0.1/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTING=OFF \
	-DCMAKE_VERBOSE_MAKEFILE=OFF \
        '$(1)'
	$(MAKE) -C '$(1).build' install
endef
