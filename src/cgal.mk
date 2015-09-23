# This file is part of MXE.
# See index.html for further information.

PKG             := cgal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.5
$(PKG)_CHECKSUM := 799e8bb275033fbd6a7af015a178bc3371cb81b166e58669029ac0eb8b6e5003
$(PKG)_SUBDIR   := CGAL-$($(PKG)_VERSION)
$(PKG)_FILE     := CGAL-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gforge.inria.fr/frs/download.php/34139/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost gmp mpfr qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gforge.inria.fr/frs/?group_id=52' | \
    grep 'CGAL-' | \
    $(SED) -n 's,.*CGAL-\([0-9][^>a-z]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCGAL_INSTALL_CMAKE_DIR:STRING="lib/CGAL" \
        -DCGAL_INSTALL_INC_DIR:STRING="include" \
        -DCGAL_INSTALL_DOC_DIR:STRING="share/doc/CGAL-$($(PKG)_VERSION)" \
        -DCGAL_INSTALL_BIN_DIR:STRING="bin" \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=OFF \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DWITH_OpenGL:BOOL=ON \
        -DWITH_ZLIB:BOOL=ON \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=OFF \
        -C '$(PWD)/src/cgal-TryRunResults.cmake' .

    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j $(JOBS) install

    cd '$(1)/examples/AABB_tree' && cmake \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=OFF \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=OFF \
        -DCGAL_DIR:STRING="../.." .
    $(MAKE) -C '$(1)/examples/AABB_tree' -j $(JOBS)
    $(INSTALL) '$(1)/examples/AABB_tree/AABB_polyhedron_edge_example.exe' '$(PREFIX)/$(TARGET)/bin/test-cgal.exe'

    cd '$(1)/examples/CGALimageIO' && cmake \
        -DWITH_CGAL_Qt3:BOOL=OFF \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=OFF \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=OFF \
        -DCGAL_DIR:STRING="../.." .
    $(MAKE) -C '$(1)/examples/CGALimageIO' -j $(JOBS)
    $(INSTALL) '$(1)/examples/CGALimageIO/convert_raw_image_to_inr.exe' '$(PREFIX)/$(TARGET)/bin/test-cgalimgio.exe'
endef

$(PKG)_BUILD_SHARED =
