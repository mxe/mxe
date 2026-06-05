# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := freecell-solver
$(PKG)_WEBSITE  := https://fc-solve.shlomifish.org/
$(PKG)_DESCR    := Freecell Solver
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.16.0
$(PKG)_CHECKSUM := 71b8882e68f1be62529069018d0c732b75078669077c96348279575849f34313
$(PKG)_SUBDIR   := freecell-solver-$($(PKG)_VERSION)
$(PKG)_FILE     := freecell-solver-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://downloads.sourceforge.net/project/fc-solve/fc-solve/$($(PKG)_FILE)
$(PKG)_DEPS     := cc rinutils

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://fc-solve.shlomifish.org/downloads/fc-solve/' | \
    grep -o 'freecell-solver-[0-9.]*\.tar\.xz' | \
    $(SED) 's/freecell-solver-//; s/\.tar\.xz//' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DFCS_WITH_TEST_SUITE=OFF \
        -DBUILD_TESTING=OFF \
        -D_PYTHON3=_PYTHON3-NOTFOUND
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
