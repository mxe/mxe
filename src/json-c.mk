# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# json-c
PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9
$(PKG)_CHECKSUM := daaf5eb960fa98e137abc5012f569b83c79be90f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://oss.metaparadigm.com/json-c/
$(PKG)_URL      := http://oss.metaparadigm.com/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --build="`config.guess`"\
        CFLAGS=-Wno-error
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
