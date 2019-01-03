# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librtmp
$(PKG)_WEBSITE  := https://rtmpdump.mplayerhq.hu/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := fa8646d
$(PKG)_CHECKSUM := 301cb9e93a7d2bf2da6b784ee6a9e45a04e2a9e3d322080d46c5d66576a792ec
$(PKG)_GH_CONF  := mirror/rtmpdump/branches/master
$(PKG)_DEPS     := cc gnutls zlib

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        CRYPTO=GNUTLS \
        $(if $(BUILD_STATIC),\
            SHARED=no \
            LIB_GNUTLS="`$(TARGET)-pkg-config --libs-only-l gnutls`" \
            XLIBS="`$(TARGET)-pkg-config --libs-only-l zlib`",) \
        -j '$(JOBS)' install
endef
