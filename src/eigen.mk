# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# eigen
PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.17
$(PKG)_CHECKSUM := 7e1674420a8eef7e90e1875ef5b9e828fb9db381
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-b23437e61a07
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://eigen.tuxfamily.org/
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    grep 'eigen/get/' | \
    $(SED) -n 's,.*eigen/get/\(2[^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
    cmake . -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' 
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
