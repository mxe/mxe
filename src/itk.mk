# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.4.1
$(PKG)_CHECKSUM := 9272a15323e9c1d44f598fca02d2bb0c16478bb5
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5

define $(PKG)_UPDATE
    echo 'TODO: Updates for package ITK need to be written.' >&2;
    echo $(itk_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -C '$(1)/TryRunResults.cmake'\
        -DBUILD_SHARED_LIBS=FALSE \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DBUILD_TESTING=FALSE \
        -DBUILD_EXAMPLES=FALSE \
        -DITK_USE_SYSTEM_HDF5=TRUE \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
