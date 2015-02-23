# This file is part of MXE.
# See index.html for further information.

PKG             := openjpeg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := c2a255f6b51ca96dc85cd6e85c89d300018cb1cb
$(PKG)_SUBDIR   := openjpeg-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/openjpeg.mirror/files/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc tiff libpng zlib lcms

#git commit 3d95bcf
define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/openjpeg.mirror/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        -DBUILD_TESTING=FALSE \
        '$(1)'
    $(MAKE) -C '$(1).build' install
endef
