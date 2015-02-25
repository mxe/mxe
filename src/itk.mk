# This file is part of MXE.
# See index.html for further information.

PKG             := itk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.0
$(PKG)_CHECKSUM := 490d221bd7441ef1d151092a72082998c597308e
$(PKG)_SUBDIR   := InsightToolkit-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc hdf5 libpng tiff jpeg expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/itk/files/itk/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -C '$(1)/TryRunResults.cmake'\
    $(if $(BUILD_SHARED),\
        -DBUILD_SHARED_LIBS=TRUE ) \
        -DBUILD_TESTING=FALSE \
        -DBUILD_EXAMPLES=FALSE \
        -DITK_USE_SYSTEM_HDF5=TRUE \
        -DITK_USE_SYSTEM_TIFF=TRUE \
        -DITK_USE_SYSTEM_PNG=TRUE \
        -DITK_USE_SYSTEM_JPEG=TRUE \
        -DITK_USE_SYSTEM_EXPAT=TRUE \
        -DVCL_CHAR_IS_SIGNED=1 \
        -DVCL_HAS_SLICED_DESTRUCTOR_BUG=1 \
        -DVCL_HAS_WORKING_STRINGSTREAM=1 \
        -DVCL_HAS_LFS=1 \
        -DVCL_COMPLEX_POW_WORKS=1 \
        -DVCL_NUMERIC_LIMITS_HAS_INFINITY=1 \
        -DVCL_PROCESSOR_HAS_INFINITY=1 \
        -DVXL_HAS_SSE2_HARDWARE_SUPPORT=1 \
        -DKWSYS_CHAR_IS_SIGNED=1 \
        -DKWSYS_LFS_WORKS=1 \
        '$(1)'

    # make and install
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install

    # install test
    $(INSTALL) -m755 '$(1).build/bin/itkTestDriver.exe' '$(PREFIX)/$(TARGET)/bin/test-itk.exe'

endef
