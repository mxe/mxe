# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xapian-core
$(PKG)_WEBSITE  := https://xapian.org/
$(PKG)_DESCR    := Xapian-Core
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.16
$(PKG)_CHECKSUM := 4937f2f49ff27e39a42150e928c8b45877b0bf456510f0785f50159a5cb6bf70
$(PKG)_SUBDIR   := xapian-core-$($(PKG)_VERSION)
$(PKG)_FILE     := xapian-core-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://oligarchy.co.uk/xapian/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://xapian.org/download | \
    $(SED) -n 's,.*<a HREF="https://oligarchy.co.uk/xapian/\([^/]*\)/xapian-core[^"]*">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
