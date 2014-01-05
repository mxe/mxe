# This file is part of MXE.
# See index.html for further information.

PKG             := chromaprint
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := 5a250f761761d2ce08e2591b9daa909393552939
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/acoustid/chromaprint/downloads/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc fftw

define $(PKG)_UPDATE
     echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DBUILD_STATIC=ON \
        -DBUILD_SHARED=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'
    $(MAKE) -C '$(1)' -j 1 install
endef
