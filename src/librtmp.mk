# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librtmp
$(PKG)_WEBSITE  := https://rtmpdump.mplayerhq.hu/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := f1b83c1
$(PKG)_CHECKSUM := f616525e1540b666c79038a9b7aa80ca73f6535dda6fd91ee1cb9d9bd2e219ba
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
