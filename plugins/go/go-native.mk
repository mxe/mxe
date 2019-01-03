# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := go-native
$(PKG)_WEBSITE  := https://golang.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.3
$(PKG)_CHECKSUM := 9947fc705b0b841b5938c48b22dc33e9647ec0752bae66e50278df4f23f64959
$(PKG)_SUBDIR   := go
$(PKG)_FILE     := go$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://storage.googleapis.com/golang/$($(PKG)_FILE)
$(PKG)_DEPS     :=
$(PKG)_TARGETS  := $(BUILD)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://golang.org/dl/' | \
    $(SED) -n 's,.*go\(1.4.[0-9][^>]*\)\.src\.tar.*,\1,p' | \
    $(SORT) -h | tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/src' && \
        GOROOT_FINAL='$(PREFIX)/$(TARGET)/go' \
        DYLD_INSERT_LIBRARIES= \
        ./make.bash

    mkdir -p '$(PREFIX)/$(TARGET)/go'
    for d in include src bin pkg; do \
        cp -a '$(1)'/$$d '$(PREFIX)/$(TARGET)/go/' ; \
    done
endef
