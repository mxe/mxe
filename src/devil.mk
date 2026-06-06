# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := devil
$(PKG)_WEBSITE  := https://openil.sourceforge.io/
$(PKG)_DESCR    := DevIL
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6f3d5e9
$(PKG)_CHECKSUM := 32f446425d6da176efaa889cc9b3cf28a3dc1b413f23e3387bf7f99b0a210be0
$(PKG)_GH_CONF  := DentonW/DevIL/branches/master
$(PKG)_DEPS     := cc freeglut jasper jpeg lcms libmng libpng openexr sdl tiff zlib

define $(PKG)_BUILD
    # for some reason, patching fails with EOL issues
    $(SED) -i 's,resources\\\\,./resources/,' '$(SOURCE_DIR)/DevIL/src-IL/msvc/IL.rc'
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)/DevIL' \
        -DIL_TESTS=OFF \
        -DCMAKE_CXX_FLAGS="-D__STDC_LIMIT_MACROS -fpermissive" \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
