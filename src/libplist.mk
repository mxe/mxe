# This file is part of MXE.
# See index.html for further information.

PKG             := libplist
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12
$(PKG)_CHECKSUM := 2d7bc731fd992a318a10195d43b11ff01b46bbb0
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/libimobiledevice/libplist/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc libxml2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libimobiledevice/libplist/archive/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(SHELL) ./autogen.sh \
        $(MXE_CONFIGURE_OPTS) \
        --without-cython
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
