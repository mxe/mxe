# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := black-hole-solver
$(PKG)_WEBSITE  := https://www.shlomifish.org/open-source/projects/black-hole-solitaire-solver/
$(PKG)_DESCR    := Black Hole Solver
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.0
$(PKG)_CHECKSUM := d32f32536f7573292588f41bb0d85ae42d561376c218dc4ab6badfe4904a37a7
$(PKG)_SUBDIR   := black-hole-solver-$($(PKG)_VERSION)
$(PKG)_FILE     := black-hole-solver-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://fc-solve.shlomifish.org/downloads/fc-solve/$($(PKG)_FILE)
$(PKG)_DEPS     := cc rinutils

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://fc-solve.shlomifish.org/downloads/fc-solve/' | \
    grep -o 'black-hole-solver-[0-9.]*\.tar\.xz' | \
    $(SED) 's/black-hole-solver-//; s/\.tar\.xz//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DBUILD_TESTING=OFF \
        -DBHS_WITH_TEST_SUITE=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
