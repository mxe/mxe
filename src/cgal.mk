# This file is part of MXE.
# See index.html for further information.

PKG             := cgal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.6.3
$(PKG)_CHECKSUM := e338027b8767c0a7a6e4fd8679182d1b83b5b1a0da0a1fe4546e7c0ca094fc21
$(PKG)_SUBDIR   := CGAL-$($(PKG)_VERSION)
$(PKG)_FILE     := CGAL-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gforge.inria.fr/frs/download.php/latestfile/2743/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost gmp mpfr qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gforge.inria.fr/frs/?group_id=52' | \
    grep 'CGAL-' | \
    $(SED) -n 's,.*CGAL-\([0-9][^>a-z]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' \
        -DCGAL_INSTALL_CMAKE_DIR:STRING="lib/CGAL" \
        -DCGAL_INSTALL_INC_DIR:STRING="include" \
        -DCGAL_INSTALL_DOC_DIR:STRING="share/doc/CGAL-$($(PKG)_VERSION)" \
        -DCGAL_INSTALL_BIN_DIR:STRING="bin" \
        -DCGAL_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=$(CMAKE_STATIC_BOOL) \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DWITH_OpenGL:BOOL=ON \
        -DWITH_ZLIB:BOOL=ON \
        -C '$(PWD)/src/cgal-TryRunResults.cmake' .

    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j $(JOBS) install

    cd '$(1)/examples/AABB_tree' && '$(TARGET)-cmake' \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DCGAL_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=$(CMAKE_STATIC_BOOL) \
        -DCGAL_DIR:STRING="../.." .
    $(MAKE) -C '$(1)/examples/AABB_tree' -j $(JOBS)
    $(INSTALL) '$(1)/examples/AABB_tree/AABB_polyhedron_edge_example.exe' '$(PREFIX)/$(TARGET)/bin/test-cgal.exe'

    cd '$(1)/examples/CGALimageIO' && '$(TARGET)-cmake' \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DCGAL_BUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=$(CMAKE_STATIC_BOOL) \
        -DCGAL_DIR:STRING="../.." .
    $(MAKE) -C '$(1)/examples/CGALimageIO' -j $(JOBS)
    $(INSTALL) '$(1)/examples/CGALimageIO/convert_raw_image_to_inr.exe' '$(PREFIX)/$(TARGET)/bin/test-cgalimgio.exe'
endef
