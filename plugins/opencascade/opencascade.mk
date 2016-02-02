# This file is part of MXE.
# See index.html for further information.

PKG             := opencascade
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.9.0
$(PKG)_CHECKSUM := e9da098b304f6b65c3958947c3c687f00128ce020b67d97554a3e3be9cf3d090
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://files.opencascade.com/OCCT/OCC_$($(PKG)_VERSION)_release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 freeimage freetype harfbuzz libpng tcl tk vtk6 zlib

# Note: Even though a more up to date library might be available, downloading it
# can require signing up on the opencascade web site.
# For example, at the time of writing this, there is a version 6.9.1 available
# that cannot be downloaded without signing up yet.
define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.opencascade.com/content/latest-release' | \
    $(SED) -n 's,.*<title>Download Open CASCADE Technology \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi && CPPFLAGS='$(if $(BUILD_STATIC),-DHAVE_NO_DLL) $(if $(findstring x86_64,$(TARGET)),-DWIN64,-DWIN32) -DFREEIMAGE_LIB -DNDEBUG' CFLAGS='-w -fpermissive' CXXFLAGS='-w -fpermissive' LIBS='-lpng -lharfbuzz -lglib-2.0 -lintl -liconv -lpsapi -lole32 -lwinmm -lwinspool -lws2_32 -lbz2 -lz' ./configure --disable-draw \
        $(MXE_CONFIGURE_OPTS) \
        --with-freeimage='$(PREFIX)/$(TARGET)' \
        --with-freetype='$(PREFIX)/$(TARGET)' \
        --with-tcl='$(PREFIX)/$(TARGET)'/lib \
        --with-tk='$(PREFIX)/$(TARGET)'/lib \
        --with-vtk-include='$(PREFIX)/$(TARGET)'/include/vtk-$(shell echo $(vtk6_VERSION) | sed -e 's/\([0-9][0-9]*\)\.\([0-9][0-9]*\)\.[0-9][0-9]*/\1.\2/') \
        --with-vtk-library='$(PREFIX)/$(TARGET)'/lib
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

    # Does not work because opencascade is a plugin
    #$(LIBTOOL) --mode=link --tag=CXX '$(TARGET)-g++' \
        -w -o '$(PREFIX)/$(TARGET)/bin/test-opencascade.exe' \
    -I'$(PREFIX)/$(TARGET)'/include/opencascade \
    $(if $(BUILD_STATIC),-DHAVE_NO_DLL) \
         '$(2).cpp' \
     $(if $(BUILD_STATIC),'$(PREFIX)/$(TARGET)'/lib/libTKXCAF.la,-lTKXCAF) \
     $(if $(BUILD_STATIC),'$(PREFIX)/$(TARGET)'/lib/libTKXDESTEP.la,-lTKXDESTEP) \
     -lspoolss -lwinspool
