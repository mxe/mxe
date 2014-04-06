# This file is part of MXE.
# See index.html for further information.

PKG             := librtmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4
$(PKG)_CHECKSUM := b65ce7708ae79adb51d1f43dd0b6d987076d7c42
$(PKG)_SUBDIR   := rtmpdump-2.3
$(PKG)_FILE     := rtmpdump-2.3.tgz
$(PKG)_URL      := http://rtmpdump.mplayerhq.hu/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package librtmp.' >&2;
    echo $(librtmp_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        CRYPTO=GNUTLS \
        SHARED=no \
        LIB_GNUTLS="`$(TARGET)-pkg-config --libs-only-l gnutls`" \
        -j '$(JOBS)' install
endef

$(PKG)_BUILD_SHARED =
