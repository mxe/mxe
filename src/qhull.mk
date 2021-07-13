# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2015.2
$(PKG)_CHECKSUM := ccba72a9d9c614181b45666f12df1a8fd0b34236099f247b9bc008f6c3ec7872
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.qhull.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qhull.' >&2;
    echo $(qhull_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $(TARGET)-cmake $(1)

    make -C '$(1)/.build' -j '$(JOBS)'
    make -C '$(1)/.build' install
endef

