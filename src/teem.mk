# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := teem
$(PKG)_WEBSITE  := https://teem.sourceforge.io/
$(PKG)_DESCR    := Teem
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.0
$(PKG)_CHECKSUM := a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc bzip2 levmar libpng pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- "https://sourceforge.net/projects/teem/files/teem/" | \
    grep 'teem/files/teem' | \
    $(SED) -n 's,.*teem/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DQNANHIBIT_VALUE=1 \
        -DQNANHIBIT_VALUE__TRYRUN_OUTPUT=1
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
