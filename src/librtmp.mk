# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librtmp
$(PKG)_WEBSITE  := https://rtmpdump.mplayerhq.hu/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6f6bb13
$(PKG)_CHECKSUM := 9ea43963306a6d1d0769dea9180345f6ce4438b82b34a56a7086a803d2412721
$(PKG)_GH_CONF  := mirror/rtmpdump/branches/master
$(PKG)_DEPS     := cc openssl zlib

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        CRYPTO=OPENSSL \
        $(if $(BUILD_STATIC),\
            SHARED=no \
            LIB_OPENSSL="`$(TARGET)-pkg-config --libs-only-l openssl`" \
            XLIBS="`$(TARGET)-pkg-config --libs-only-l zlib`",) \
        -j '$(JOBS)' install
endef
