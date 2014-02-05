# This file is part of MXE.
# See index.html for further information.

PKG             := xmlrpc-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.33.7
$(PKG)_CHECKSUM := 2f1b1ac796247d412ebdbfa5d0a91dc286da6820
$(PKG)_SUBDIR   := xmlrpc-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xmlrpc-c-$($(PKG)_VERSION).tgz
# there is no .tgz for the "stable" branch on sourceforge.net so I have created one myself and put it on my server.
# is there a way to pull from the sourceforge.net svn instead ? 
$(PKG)_URL      := http://doido.aline.nu/~lars/src/$($(PKG)_FILE)
$(PKG)_DEPS     := curl pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/p/xmlrpc-c/svn/HEAD/tree/release_number/' | \
    grep '<a href="' | \
    $(SED) -n 's,.*<a href="release-\([0-9][^"]*\)".*,\1,p' | \
    tail -1
endef

TMP_BIN_DIR := $(realpath .)/tmp-$(PKG)/curl-bin

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-curl-client \
        --enable-abyss-server \
        --enable-cgi-server \
        --enable-cplusplus \
        --enable-abyss-threads

    mkdir $(TMP_BIN_DIR); cd $(TMP_BIN_DIR); ln -s $(PREFIX)/$(TARGET)/bin/curl-config
    PATH=$(TMP_BIN_DIR):$(PATH) $(MAKE) -C '$(1)' -j '$(JOBS)' BUILDTOOL_CC=gcc BUILDTOOL_CCLD=gcc
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
