# This file is part of MXE.
# See index.html for further information.

PKG             := cgal
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 20c58ebc021754e8be35237bcda43b0084f60617
$(PKG)_SUBDIR   := CGAL-$($(PKG)_VERSION)
$(PKG)_FILE     := CGAL-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://gforge.inria.fr/frs/download.php/31176/$($(PKG)_FILE)
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
        -DBOOST_LIB_DIAGNOSTIC_DEFINITIONS:STRING="-DBOOST_LIB_DIAGNOSTIC" \
        -DWITH_CGAL_Qt3:BOOL="0" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBOOST_COMPILER=_win32 \
        -DBOOST_THREAD_USE_LIB=1 \
        -DBOOST_USE_STATIC_LIBS=1 \
        -DBUILD_SHARED_LIBS=0 \
        -C TryRunResults.cgal.cmake .
    $(MAKE) -C '$(1)' -j $(JOBS)
    cd '$(1)/examples/AABB_tree' && cmake \
        -DBOOST_LIB_DIAGNOSTIC_DEFINITIONS:STRING="-DBOOST_LIB_DIAGNOSTIC" \
        -DWITH_CGAL_Qt3:BOOL="0" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBOOST_COMPILER=_win32 \
        -DBOOST_THREAD_USE_LIB=1 \
        -DBOOST_USE_STATIC_LIBS=1 \
        -DBUILD_SHARED_LIBS=0 \
        -DCGAL_DIR:STRING="../.." .

    $(MAKE) -C '$(1)/examples/AABB_tree' -j $(JOBS)
    $(MAKE) -C '$(1)' -j $(JOBS) install
    $(INSTALL) '$(1)/examples/AABB_tree/AABB_polyhedron_edge_example.exe' '$(PREFIX)/$(TARGET)/bin/test-cgal.exe'
endef
