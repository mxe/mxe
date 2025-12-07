# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsbml
$(PKG)_WEBSITE  := https://sbml.org/software/libsbml/
$(PKG)_DESCR    := Systems Biology Markup Language library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.20.5
$(PKG)_CHECKSUM := 21c88c753a4a031f157a033de3810488b86f003e684c6ca7aa3d6e26e7e0acfc
$(PKG)_FILE     := v$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/sbmlteam/$(PKG)/archive/refs/tags/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 zlib expat

define $(PKG)_UPDATE
    echo 'TODO: write update script for $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)/$(PKG)-$($(PKG)_VERSION)' \
          -DLIBSBML_DEPENDENCY_DIR=$(PREFIX)/$(TARGET) \
          -DLIBSBML_SKIP_SHARED_LIBRARY=ON \
          -DCMAKE_INSTALL_PREFIX=${PREFIX}/$(TARGET) \
          -DCMAKE_BUILD_TYPE=Release \
          -DWITH_CPP_NAMESPACE=ON \
          -DWITH_SWIG=OFF \
          -DWITH_LIBXML=OFF \
          -DWITH_EXPAT=ON \
          -DWITH_ZLIB=ON \
          -DWITH_BZIP2=ON \
          -DENABLE_COMP=ON \
          -DENABLE_FBC=ON \
          -DENABLE_GROUPS=ON \
          -DENABLE_L3V2EXTENDEDMATH=ON \
          -DENABLE_LAYOUT=ON \
          -DENABLE_MULTI=ON \
          -DENABLE_QUAL=ON \
          -DENABLE_RENDER=ON
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --build . -j '$(JOBS)'
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' --install .
    
    # Make pkg-config's -lsbml actually resolvable in the static triplet
    cd '$(PREFIX)/$(TARGET)/lib' && \
        ln -sf $(PKG)-static.a $(PKG).a
    
    '$(TARGET)-g++' \
        -W -Wall -ansi -pedantic -std=c++17 \
        '$(SOURCE_DIR)$(PKG)-$($(PKG)_VERSION)/examples/c++/fbc/fbc_example1.cpp' \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' libsbml expat zlib --cflags --libs`
endef



