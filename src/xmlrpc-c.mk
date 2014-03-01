# This file is part of MXE.
# See index.html for further information.

PKG             := xmlrpc-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d4364f4
$(PKG)_CHECKSUM := 3f0cb2a5967832fa5463bd85740eb04911488da9
$(PKG)_SUBDIR   := mirror-$(PKG)-$($(PKG)_VERSION)/advanced
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc curl pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/mirror/xmlrpc-c/commits/master' | \
    grep 'title="Release' | \
    $(SED) -n 's,.*/mirror/xmlrpc-c/commit/\([^"]\{7\}\)[^"]\{33\}".*Release \([0-9]*\),\1 \2,p' | \
    $(SORT) -V -k 2 | \
    tail -1 | \
    cut -d ' ' -f1
endef

$(PKG)_MAKE_OPTS = \
    BUILDTOOL_CC=gcc \
    BUILDTOOL_CCLD=gcc \
    SHARED_LIB_TYPE=@xmlrpc-c-shared-lib-type@ \
    MUST_BUILD_SHLIB=@xmlrpc-c-must-build-shlib@

define $(PKG)_BUILD_COMMON
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-abyss-server=no \
        --enable-cgi-server=no \
        --enable-cplusplus \
        --enable-curl-client \
        CURL_CONFIG='$(PREFIX)/$(TARGET)/bin/curl-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)
    $(MAKE) -C '$(1)' -j 1 install $($(PKG)_MAKE_OPTS)
endef

$(PKG)_BUILD_STATIC=$(subst @xmlrpc-c-shared-lib-type@,NONE,\
                    $(subst @xmlrpc-c-must-build-shlib@,N,\
                    $($(PKG)_BUILD_COMMON)))

$(PKG)_BUILD_SHARED=$(subst @xmlrpc-c-shared-lib-type@,dll,\
                    $(subst @xmlrpc-c-must-build-shlib@,Y,\
                    $($(PKG)_BUILD_COMMON)))
