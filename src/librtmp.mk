# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := librtmp
$(PKG)_WEBSITE  := https://rtmpdump.mplayerhq.hu/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := a107cef
$(PKG)_CHECKSUM := aea53f2a2c6596c93eeb288d97266e89a97b31795b678daccedc31d70dad28c4
$(PKG)_SUBDIR   := mirror-rtmpdump-$($(PKG)_VERSION)
$(PKG)_FILE     := rtmpdump-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mirror/rtmpdump/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gnutls

$(PKG)_UPDATE = $(call MXE_GET_GITHUB_SHA, mirror/rtmpdump, master)

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        CRYPTO=GNUTLS \
        $(if $(BUILD_STATIC),\
            SHARED=no \
            LIB_GNUTLS="`$(TARGET)-pkg-config --libs-only-l gnutls`",) \
        -j '$(JOBS)' install
endef
