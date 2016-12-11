# mxe/src/neon.mk
# This file is part of MXE.
# See index.html for further information.

# libneon	http://webdav.org/neon/
# 
# neon is an HTTP and WebDAV client library, with a C interface. Features:
# 
# - High-level wrappers for common HTTP and WebDAV operations (GET, MOVE, DELETE, etc)
# - Low-level interface to the HTTP request/response engine, allowing the use of arbitrary HTTP methods, headers, etc.
# - Authentication support including Basic and Digest support, along with GSSAPI-based Negotiate on Unix, and SSPI-based Negotiate/NTLM on Win32
# - SSL/TLS support using OpenSSL or GnuTLS; exposing an abstraction layer for verifying server certificates, handling client certificates, and examining certificate properties. Smartcard-based client certificates are also supported via a PKCS#11 wrapper interface.
# - Abstract interface to parsing XML using libxml2 or expat, and wrappers for simplifying handling XML HTTP response bodies
# - WebDAV metadata support; wrappers for PROPFIND and PROPPATCH to simplify property manipulation.
# 
# http://webdav.org/neon/neon-0.30.2.tar.gz

PKG             := neon
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.30.2
$(PKG)_CHECKSUM := db0bd8cdec329b48f53a6f00199c92d5ba40b0f015b153718d1b15d3d967fbca
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://webdav.org/$(PKG)/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc openssl expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://webdav.org/$(PKG)/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/"\.tar.*,\1,p' | \
    sort | uniq | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && \
        ne_cv_fmt_size_t=%lu \
        ne_cv_fmt_ssize_t=%lu \
        ne_cv_fmt_off64_t=%I64u \
        ne_cv_fmt_time_t=%lu \
        ne_cv_libsfor_socket=-lws2_32 \
        ne_cv_libsfor_gethostbyname=-lws2_32 \
    	./configure \
        $(MXE_CONFIGURE_OPTS) \
	--with-ssl=yes 
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef

$(PKG)_BUILD_i686-pc-mingw32    = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_i686-w64-mingw32   = $(subst @special-target@, x86-win32-gcc,    $($(PKG)_BUILD))
$(PKG)_BUILD_x86_64-w64-mingw32 = $(subst @special-target@, x86_64-win64-gcc, $($(PKG)_BUILD))

