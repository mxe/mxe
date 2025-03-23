# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cpp-netlib
$(PKG)_WEBSITE  := https://cpp-netlib.org/
$(PKG)_DESCR    := Boost C++ Networking Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.0
$(PKG)_CHECKSUM := 897259d9f9087acba33911aec925804e6236a7a77f5444dedde6145049605a34
$(PKG)_GH_CONF  := cpp-netlib/cpp-netlib/tags,cpp-netlib-,-final
$(PKG)_DEPS     := cc boost openssl

define $(PKG)_BUILD
   mkdir '$(1)/build'
   cd '$(1)/build' && '$(TARGET)-cmake' .. \
       -DINSTALL_CMAKE_DIR='$(PREFIX)/$(TARGET)/cmake/cppnetlib' \
       -DCPP-NETLIB_BUILD_EXAMPLES=OFF \
       -DCPP-NETLIB_BUILD_TESTS=OFF

   $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
