# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cgal
$(PKG)_WEBSITE  := https://www.cgal.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.11
$(PKG)_CHECKSUM := 27a7762e5430f5392a1fe12a3a4abdfe667605c40224de1c6599f49d66cfbdd2
# using / in tag name means we have to set SUBDIR, FILE, URL
$(PKG)_GH_CONF  := CGAL/cgal/tags, releases%2FCGAL-
$(PKG)_SUBDIR   := CGAL-$($(PKG)_VERSION)
$(PKG)_FILE     := CGAL-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/CGAL/cgal/releases/download/releases/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc boost gmp mpfr qt5

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCGAL_INSTALL_CMAKE_DIR:STRING="lib/CGAL" \
        -DCGAL_INSTALL_INC_DIR:STRING="include" \
        -DCGAL_INSTALL_DOC_DIR:STRING="share/doc/CGAL-$($(PKG)_VERSION)" \
        -DCGAL_INSTALL_BIN_DIR:STRING="bin" \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=$(CMAKE_STATIC_BOOL) \
        -DWITH_OpenGL:BOOL=ON \
        -DWITH_ZLIB:BOOL=ON \
        -C'$(PWD)/src/cgal-TryRunResults.cmake'

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    mkdir '$(BUILD_DIR).test-tree'
    cd '$(BUILD_DIR).test-tree' && '$(TARGET)-cmake' '$(SOURCE_DIR)/examples/AABB_tree'
    $(MAKE) -C '$(BUILD_DIR).test-tree' -j $(JOBS)
    $(INSTALL) '$(BUILD_DIR).test-tree/AABB_polyhedron_edge_example.exe' '$(PREFIX)/$(TARGET)/bin/test-cgal.exe'

    mkdir '$(BUILD_DIR).test-image'
    cd '$(BUILD_DIR).test-image' && '$(TARGET)-cmake' '$(SOURCE_DIR)/examples/CGALimageIO'
    $(MAKE) -C '$(BUILD_DIR).test-image' -j $(JOBS)
    $(INSTALL) '$(BUILD_DIR).test-image/convert_raw_image_to_inr.exe' '$(PREFIX)/$(TARGET)/bin/test-cgalimgio.exe'
endef
