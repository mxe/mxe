# This file is part of MXE.
# See index.html for further information.

PKG             := muparser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.5
$(PKG)_CHECKSUM := 3a7e1c94865abd11c8ade7824241eb9eacfc252f4d4214723a5f06d19563f5e0
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := beltoforion/muparser
$(PKG)_GH_TAG_PFX := v
$(PKG)_GH_TAG_SHA := 57e7e28
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
