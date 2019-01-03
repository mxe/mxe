# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cppzmq
$(PKG)_WEBSITE  := https://github.com/zeromq/cppzmq
$(PKG)_DESCR    := C++ binding for 0MQ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.2
$(PKG)_CHECKSUM := 3ef50070ac5877c06c6bb25091028465020e181bbfd08f110294ed6bc419737d
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
