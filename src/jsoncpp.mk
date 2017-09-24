# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jsoncpp
$(PKG)_WEBSITE  := https://github.com/open-source-parsers/jsoncpp
$(PKG)_DESCR    := A C++ library for interacting with JSON
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.3
$(PKG)_CHECKSUM := 3671ba6051e0f30849942cc66d1798fdf0362d089343a83f704c09ee7156604f
$(PKG)_GH_CONF  := open-source-parsers/jsoncpp,,,svn
$(PKG)_DEPS     := gcc

# workaround for builds with GCC >= 6.x
$(PKG)_CXXFLAGS := -Wno-error=conversion -Wno-shift-negative-value

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF \
        -DCMAKE_CXX_FLAGS="$($(PKG)_CXXFLAGS)" \
        -DJSONCPP_WITH_CMAKE_PACKAGE=ON
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
