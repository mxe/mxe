# This file is part of MXE. See LICENSE.md for licensing information.

PKG               := vtk
$(PKG)_IGNORE     :=
$(PKG)_VERSION    := 8.2.0
$(PKG)_CHECKSUM   := 34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb
$(PKG)_SUBDIR     := VTK-$($(PKG)_VERSION)
$(PKG)_FILE       := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL        := https://www.vtk.org/files/release/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_QT_VERSION := 5
$(PKG)_DEPS       := cc expat freetype glew hdf5 jsoncpp libpng libxml2 lz4 qtbase qttools tiff $(BUILD)~$(PKG)

$(PKG)_TARGETS       := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://vtk.org/gitweb?p=VTK.git;a=tags' | \
    grep 'refs/tags/v[0-9.]*"' | \
    $(SED) 's,.*refs/tags/v\(.*\)".*,\1,g;' | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD_$(BUILD)
    # first we need a native build to create the compile tools
    # must be built in dest since there's no way to install tools only
    # and the build rules reference certain make targets
    rm -rf '$(PREFIX)/$(BUILD)/vtkCompileTools'
    $(INSTALL) -d '$(PREFIX)/$(BUILD)/vtkCompileTools'
    cd '$(PREFIX)/$(BUILD)/vtkCompileTools' && '$(PREFIX)/$(BUILD)/bin/cmake' '$(SOURCE_DIR)' \
        -DBUILD_TESTING=FALSE \
        -DVTK_USE_X=OFF \
        -DVTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=ON \
        -DCMAKE_BUILD_TYPE="Release"
    $(MAKE) -C '$(PREFIX)/$(BUILD)/vtkCompileTools' -j '$(JOBS)' VERBOSE=1 vtkCompileTools
endef

define $(PKG)_BUILD
    # DirectX is detected on Mac OSX but we use OpenGL
    $(SED) -i 's,d3d9,nod3d9,g' '$(1)/CMake/FindDirectX.cmake'

    # now the cross compilation
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DVTKCompileTools_DIR='$(PREFIX)/$(BUILD)/vtkCompileTools' \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DVTK_Group_Qt=ON \
        -DVTK_Group_Imaging=ON \
        -DVTK_QT_VERSION=$($(PKG)_QT_VERSION) \
        -DVTK_USE_CXX11_FEATURES=ON \
        -DVTK_USE_SYSTEM_LIBRARIES=OFF \
        -DVTK_USE_SYSTEM_LIBPROJ4=OFF \
        -DVTK_USE_SYSTEM_NETCDF=OFF \
        -DVTK_USE_SYSTEM_NETCDFCPP=OFF \
        -DVTK_USE_SYSTEM_GL2PS=OFF \
        -DVTK_USE_SYSTEM_TIFF=ON \
        -DVTK_USE_SYSTEM_HDF5=ON \
        -DVTK_USE_SYSTEM_GLEW=ON \
        -DVTK_FORBID_DOWNLOADS=ON \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        $(PKG_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1

    #now build the GUI -> Qt -> SimpleView Example
    mkdir '$(BUILD_DIR).test'
    cd '$(BUILD_DIR).test' && '$(TARGET)-cmake' \
        '$(SOURCE_DIR)/Examples/GUI/Qt/SimpleView'
    $(MAKE) -C '$(BUILD_DIR).test' -j '$(JOBS)' VERBOSE=1
    $(INSTALL) '$(BUILD_DIR).test/SimpleView.exe' $(PREFIX)/$(TARGET)/bin/test-$(PKG).exe
endef
