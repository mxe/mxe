# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cpp-netlib
$(PKG)_WEBSITE  := https://cpp-netlib.org/
$(PKG)_DESCR    := Boost C++ Networking Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 73d4024
$(PKG)_CHECKSUM := 576f18cbad20ab123db68c72d1e541387a8b5d3b191698e44e2d96936a1f323b
$(PKG)_GH_CONF  := cpp-netlib/cpp-netlib/branches/0.13-release
$(PKG)_DEPS     := cc boost openssl

define $(PKG)_BUILD
   mkdir '$(1)/build'
   cd '$(1)/build' && '$(TARGET)-cmake' .. \
       -DINSTALL_CMAKE_DIR='$(PREFIX)/$(TARGET)/cmake/cppnetlib' \
       -DCPP-NETLIB_BUILD_EXAMPLES=OFF \
       -DCPP-NETLIB_BUILD_TESTS=OFF

   $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
