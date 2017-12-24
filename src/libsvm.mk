# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsvm
$(PKG)_WEBSITE  := https://www.csie.ntu.edu.tw/~cjlin/libsvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.22
$(PKG)_CHECKSUM := 6d81c67d3b13073eb5a25aa77188f141b242ec328518fad95367ede253d0a77d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.csie.ntu.edu.tw/~cjlin/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.csie.ntu.edu.tw/~cjlin/libsvm/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)'

    $(MAKE) -C '$(1).build' install

endef
