# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xmlrpc-c
$(PKG)_WEBSITE  := https://xmlrpc-c.sourceforge.io/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := d4364f4
$(PKG)_CHECKSUM := fbd79d86020a87ed61dfdf00f78873c0fd925f477a8705f415b9fee0d6d64b19
$(PKG)_GH_CONF  := mirror/xmlrpc-c/branches/master
$(PKG)_DEPS     := cc curl pthreads

$(PKG)_MAKE_OPTS = \
    BUILDTOOL_CC=$(BUILD_CC) \
    BUILDTOOL_CCLD=$(BUILD_CC) \
    SHARED_LIB_TYPE=@xmlrpc-c-shared-lib-type@ \
    MUST_BUILD_SHLIB=@xmlrpc-c-must-build-shlib@

define $(PKG)_BUILD_COMMON
    $(SED) -i 's,curl-config,$(TARGET)-curl-config,g' '$(1)/advanced/lib/curl_transport/Makefile'
    $(SED) -i 's,curl-config,$(TARGET)-curl-config,g' '$(1)/advanced/src/Makefile'
    cd '$(1)/advanced' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-abyss-server=no \
        --enable-cgi-server=no \
        --enable-cplusplus \
        --enable-curl-client \
        CURL_CONFIG='$(PREFIX)/$(TARGET)/bin/curl-config'
    $(MAKE) -C '$(1)/advanced' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)
    $(MAKE) -C '$(1)/advanced' -j 1 install $($(PKG)_MAKE_OPTS)

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(1)/advanced/examples/cpp/asynch_client.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-xmlrpc-c.exe' \
        `'$(PREFIX)/$(TARGET)/bin/xmlrpc-c-config' c++2 client --libs` \
        `'$(TARGET)-pkg-config' libcurl --cflags --libs`
endef

$(PKG)_BUILD_STATIC=$(subst @xmlrpc-c-shared-lib-type@,NONE,\
                    $(subst @xmlrpc-c-must-build-shlib@,N,\
                    $($(PKG)_BUILD_COMMON)))

#$(PKG)_BUILD_SHARED=$(subst @xmlrpc-c-shared-lib-type@,dll,\
#                    $(subst @xmlrpc-c-must-build-shlib@,Y,\
#                    $($(PKG)_BUILD_COMMON)))
