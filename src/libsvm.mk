# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsvm
$(PKG)_WEBSITE  := https://www.csie.ntu.edu.tw/~cjlin/libsvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 322
$(PKG)_CHECKSUM := a3469436f795bb3f8b1e65ea761e14e5599ec7ee941c001d771c07b7da318ac6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.csie.ntu.edu.tw/~cjlin/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/cjlin1/libsvm/releases' | \
    $(SED) -n '/a href/ s_.*releases/tag/v\([0-9.]*\)".*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(TARGET)-cmake' '$(1)'

    $(MAKE) -C '$(1).build' install

endef
