# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := mxml
$(PKG)_WEBSITE  := https://michaelrsweet.github.io/mxml/
$(PKG)_DESCR    := Mini-XML
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.10
$(PKG)_CHECKSUM := 267ff58b64ddc767170d71dab0c729c06f45e1df9a9b6f75180b564f09767891
$(PKG)_GH_CONF  := michaelrsweet/mxml, release-
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/michaelrsweet/mxml/releases/download/release-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' libmxml.a
    $(MAKE) -C '$(1)' -j 1 install-libmxml.a
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/mxml.h'  '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d                   '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-mxml.exe' \
        `'$(TARGET)-pkg-config' mxml --cflags --libs`
endef

$(PKG)_BUILD_SHARED =
