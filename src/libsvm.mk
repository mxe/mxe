# This file is part of MXE.
# See index.html for further information.

PKG             := libsvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.20
$(PKG)_CHECKSUM := 6902c22afadc70034c0d1c0e25455df10fb01eaf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.csie.ntu.edu.tw/~cjlin/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.csie.ntu.edu.tw/~cjlin/libsvm/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=$(if $(BUILD_STATIC),FALSE,TRUE) \
        '$(1)'

    $(MAKE) -C '$(1).build' install

endef
