# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := devil
$(PKG)_WEBSITE  := https://openil.sourceforge.io/
$(PKG)_DESCR    := DevIL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := cba359b
$(PKG)_CHECKSUM := 18323d6ac0a9e5109b0f461c628e24fc2666eee5bd476aaca8cbcdb2dae9e211
$(PKG)_GH_CONF  := DentonW/DevIL/branches/master
$(PKG)_DEPS     := cc freeglut jasper jpeg lcms libmng libpng openexr sdl tiff zlib

define $(PKG)_BUILD
    # for some reason, patching fails with EOL issues
    $(SED) -i 's,resources\\\\,./resources/,' '$(SOURCE_DIR)/DevIL/src-IL/msvc/IL.rc'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)/DevIL' \
        -DIL_TESTS=OFF \
        -DCMAKE_CXX_FLAGS="-D__STDC_LIMIT_MACROS -fpermissive"
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
