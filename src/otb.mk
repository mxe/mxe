# This file is part of MXE.
# See index.html for further information.

PKG             := otb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := c4f1299a2828a6f6acb81c1e022c706b7b7f10ea
$(PKG)_SUBDIR   := OTB-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tgz
$(PKG)_URL      := http://orfeo-toolbox.org/packages/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gdal expat itk ossim opencv boost curl qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/itk/files/itk/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
#copy otb.conf to build directory.
    cp '$(1)/otb.conf' '$(1).build/otb.conf'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        $(if $(BUILD_SHARED), -DBUILD_SHARED_LIBS=TRUE ) \
        $(if $(BUILD_STATIC), -DBUILD_SHARED_LIBS=FALSE ) \
        -DBUILD_TESTING=FALSE \
        -DBUILD_EXAMPLES=FALSE \
        -DBUILD_APPLICATIONS=TRUE \
        -DCMAKE_USE_WIN32_THREADS=TRUE \
        -DGDAL_CONFIG='$(PREFIX)/$(TARGET)/bin/gdal-config' \
        -DOSSIM_LIBRARY='$(PREFIX)/$(TARGET)/lib/libossim.dll.a;$(PREFIX)/$(TARGET)/lib/libOpenThreads.dll.a' \
        -DOTB_COMPILE_WITH_FULL_WARNING=FALSE \
        -DOTB_USE_PATENTED=TRUE \
        -DOTB_USE_CURL=TRUE \
        -DOTB_USE_EXTERNAL_BOOST=TRUE \
        -DOTB_USE_EXTERNAL_EXPAT=TRUE \
        -DOTB_USE_EXTERNAL_ITK=TRUE \
        -DOTB_USE_EXTERNAL_OSSIM=TRUE \
        -DOTB_USE_MAPNIK=FALSE \
        -DOTB_USE_OPENCV=TRUE \
        -DOTB_WRAP_JAVA=FALSE \
        -DOTB_WRAP_PYTHON=FALSE \
        -DOTB_WRAP_QT=TRUE \
        -DOTB_USE_SIFTFAST=TRUE \
        -C$(if $(findstring x86_64,$(TARGET)),'$(1)/TryRunResults_x86_64.cmake', \
            $(if $(findstring i686,$(TARGET)),'$(1)/TryRunResults.cmake'))  \
        '$(1)'

    $(MAKE) -C '$(1).build' -j '$(JOBS)'
#install
    $(MAKE) -C '$(1).build' -j 1 install
# install test
    $(INSTALL) -m755 '$(1).build/bin/otbTestDriver.exe' '$(PREFIX)/$(TARGET)/bin/test-otb.exe'

endef
