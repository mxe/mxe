# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := jsoncpp
$(PKG)_WEBSITE  := https://github.com/open-source-parsers/jsoncpp
$(PKG)_DESCR    := A C++ library for interacting with JSON
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.0
$(PKG)_CHECKSUM := 5deb2462cbf0c0121c9d6c9823ec72fe71417e34242e3509bc7c003d526465bc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/open-source-parsers/jsoncpp/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

# workaround for builds with GCC >= 6.x
$(PKG)_CXXFLAGS := -Wno-error=conversion -Wno-shift-negative-value

define $(PKG)_UPDATE
    $(call MXE_GET_GITHUB_TAGS, open-source-parsers/jsoncpp)
endef

define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && '$(TARGET)-cmake' .. \
        -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF \
        -DCMAKE_CXX_FLAGS="$($(PKG)_CXXFLAGS)" \
        -DJSONCPP_WITH_CMAKE_PACKAGE=ON
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
