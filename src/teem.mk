# This file is part of MXE.
# See index.html for further information.

PKG             := teem
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.11.0
$(PKG)_CHECKSUM := a01386021dfa802b3e7b4defced2f3c8235860d500c1fa2f347483775d4c8def
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-src
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc bzip2 levmar libpng pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://sourceforge.net/projects/teem/files/teem/" | \
    grep 'teem/files/teem' | \
    $(SED) -n 's,.*teem/\([0-9][^>]*\)/.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake . \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DQNANHIBIT_VALUE=1 -DQNANHIBIT_VALUE__TRYRUN_OUTPUT=1
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1
endef

$(PKG)_BUILD_SHARED =
