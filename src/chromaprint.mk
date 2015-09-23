# This file is part of MXE.
# See index.html for further information.

PKG             := chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := 6b14d7ea4964581b73bd3f8038c8857c01e446421c1ae99cbbf64de26b47cd12
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/acoustid/chromaprint/downloads/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc ffmpeg

define $(PKG)_UPDATE
    echo 'TODO: Updates for package chromaprint need to be written.' >&2;
    echo $(chromaprint_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_SHARED),ON,OFF)
    $(MAKE) -C '$(1)' -j 1 install
endef
