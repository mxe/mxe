# This file is part of MXE.
# See index.html for further information.

PKG             := cpp-netlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.11.2
$(PKG)_CHECKSUM := 71953379c5a6fab618cbda9ac6639d87b35cab0600a4450a7392bc08c930f2b1
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
   cd '$(1)/build' && cmake .. \
       -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
       -DINSTALL_CMAKE_DIR='$(PREFIX)/$(TARGET)/cmake/$(PKG)' \
       -DCPP-NETLIB_BUILD_EXAMPLES=OFF \
       -DCPP-NETLIB_BUILD_TESTS=OFF

   $(MAKE) -C '$(1)/build' -j '$(JOBS)' install
endef
