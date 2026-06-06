# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cppzmq
$(PKG)_WEBSITE  := https://github.com/zeromq/cppzmq
$(PKG)_DESCR    := C++ binding for 0MQ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.11.0
$(PKG)_CHECKSUM := 0fff4ff311a7c88fdb76fceefba0e180232d56984f577db371d505e4d4c91afd
$(PKG)_GH_CONF  := zeromq/cppzmq/tags,v
$(PKG)_DEPS     := cc libzmq

define $(PKG)_BUILD
    # install the headers only
    $(INSTALL) -m644 '$(SOURCE_DIR)'/zmq*.hpp '$(PREFIX)/$(TARGET)/include'

    # test cmake
    mkdir '$(BUILD_DIR).test-cmake'
    cd '$(BUILD_DIR).test-cmake' && '$(TARGET)-cmake' \
        -DPKG=$(PKG) \
        -DPKG_VERSION=$($(PKG)_VERSION) \
        '$(PWD)/src/cmake/test'
    $(MAKE) -C '$(BUILD_DIR).test-cmake' -j 1 install
endef
