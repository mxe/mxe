# This file is part of MXE.
# See index.html for further information.

PKG             := libsvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.20
$(PKG)_CHECKSUM := 0f122480bef44dec4df6dae056f468c208e4e08c00771ec1b6dae2707fd945be
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
