# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# vtk
PKG             := vtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.8.0
$(PKG)_CHECKSUM := ece52f4fa92811fe927581e60ecb39a8a5f68cd9
$(PKG)_SUBDIR   := VTK
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.vtk.org/
$(PKG)_URL      := $($(PKG)_WEBSITE)files/release/5.8/$($(PKG)_FILE)
$(PKG)_DEPS     := qt expat freetype jpeg libxml2 libpng tiff zlib libodbc++ postgresql

define $(PKG)_UPDATE
    wget -q -O- 'http://vtk.org/gitweb?p=VTK.git;a=tags' | \
    grep 'refs/tags/v[0-9.]*"' | \
    $(SED) 's,.*refs/tags/v\(.*\)".*,\1,g;' | \
    head -1
endef

define $(PKG)_BUILD

    # first we need a native build to create the compile tools
    mkdir '$(1)/native_build'
    cd '$(1)/native_build' && cmake \
        -DCMAKE_BUILD_TYPE='Release' \
        -DBUILD_TESTING=FALSE \
        -DOPENGL_INCLUDE_DIR='$(1)/Utilities/ParseOGLExt/headers' \
        -DVTK_USE_RENDERING=FALSE \
        ..
    
    # only the newly created CompileTools target need to be built
    $(MAKE) -C '$(1)/native_build' -j '$(JOBS)' VERBOSE=1 CompileTools
        
    # DirectX is detected on Mac OSX but requires a DX10 header - dxgi.h
    rm '$(1)/CMake/FindDirectX.cmake'
    
    # now for the cross compilation
    mkdir '$(1)/cross_build'
    cd '$(1)/cross_build' && cmake \
        -C '$(1)/TryRunResults.cmake'\
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'\
        -DBUILD_TESTING=FALSE\
        -DVTKCompileTools_DIR='$(1)/native_build'\
        -DVTK_USE_SYSTEM_EXPAT=TRUE\
        -DVTK_USE_SYSTEM_FREETYPE=TRUE\
        -DVTK_USE_SYSTEM_JPEG=TRUE\
        -DVTK_USE_SYSTEM_LIBXML2=TRUE\
        -DVTK_USE_SYSTEM_PNG=TRUE\
        -DVTK_USE_SYSTEM_TIFF=TRUE\
        -DVTK_USE_SYSTEM_ZLIB=TRUE\
        -DVTK_USE_QT=TRUE\
        -DVTK_USE_POSTGRES=TRUE\
        -DVTK_USE_ODBC=TRUE\
        ..
    $(MAKE) -C '$(1)/cross_build' -j '$(JOBS)' install VERBOSE=1
endef
