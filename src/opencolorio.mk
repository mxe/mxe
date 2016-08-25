# This file is part of MXE.
# See index.html for further information.

PKG             := opencolorio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := 27c81e691c15753cd2b560c2ca4bd5679a60c2350eedd43c99d44ca25d65ea7f
$(PKG)_SUBDIR   := OpenColorIO-$($(PKG)_VERSION)
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/imageworks/OpenColorIO/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc 

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, imageworks/OpenCOlorIO, master) | $(SED) 's/^\(.......\).*/\1/;'

define $(PKG)_BUILD

    cd '$(1)' && mkdir build && cd build && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DOCIO_BUILD_APPS=OFF \
        -DOCIO_BUILD_TRUELIGHT=OFF \
        -DOCIO_BUILD_NUKE=OFF \
        -DOCIO_BUILD_DOCS=OFF \
        -DOCIO_BUILD_TESTS=OFF \
        -DOCIO_BUILD_PYGLUE=OFF 

    $(MAKE) -C '$(1)'/build -j '$(JOBS)' install VERBOSE=1


endef
