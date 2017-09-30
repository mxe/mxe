# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cpp-netlib
$(PKG)_WEBSITE  := http://cpp-netlib.org/
$(PKG)_DESCR    := Boost C++ Networking Library
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12.0
$(PKG)_CHECKSUM := a0a4a5cbb57742464b04268c25b80cc1fc91de8039f7710884bf8d3c060bd711
$(PKG)_SUBDIR   := cpp-netlib-$($(PKG)_VERSION)-final
$(PKG)_FILE     := cpp-netlib-$($(PKG)_VERSION)-final.tar.gz
$(PKG)_URL      := http://downloads.cpp-netlib.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cpp-netlib.org/' | \
    $(SED) -n 's,.*cpp-netlib-\([0-9][^"]*\)-final.tar.gz.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
   mkdir '$(1)/build'
   cd '$(1)/build' && '$(TARGET)-cmake' .. \
       -DINSTALL_CMAKE_DIR='$(PREFIX)/$(TARGET)/cmake/cppnetlib' \
       -DCPP-NETLIB_BUILD_EXAMPLES=OFF \
       -DCPP-NETLIB_BUILD_TESTS=OFF

   $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
