# This file is part of MXE.
# See index.html for further information.
PKG             := ossim
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.18
$(PKG)_CHECKSUM := 64a1018148d3ea4e53b47940e24aba2bff3c9185
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/mxedeps/files/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg tiff proj libpng geos openthreads

define $(PKG)_UPDATE
    echo 'TODO: Updates for package OSSIM need to be written.' >&2;
    echo $(itk_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=ON \
	-DCMAKE_MODULE_PATH='$(1)/CMakeModukes' \
        '$(1)'
  $(MAKE) -C '$(1).build' -j '$(JOBS)' install 
endef
