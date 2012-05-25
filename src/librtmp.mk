# This file is part of MXE.
# See index.html for further information.

PKG             := librtmp
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := b65ce7708ae79adb51d1f43dd0b6d987076d7c42
$(PKG)_SUBDIR   := rtmpdump-$($(PKG)_VERSION)
$(PKG)_FILE     := rtmpdump-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://rtmpdump.mplayerhq.hu/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc openssl

define $(PKG)_UPDATE
    wget -q -O- 'http://rtmpdump.mplayerhq.hu/download/' | \
    $(SED) -n 's,.*rtmpdump-\([0-9.]*\)\.tgz.*,\1,ip' | \
    sort -r | \
    head -1
endef

define $(PKG)_BUILD
    make -C '$(1)' \
        CROSS_COMPILE='$(TARGET)-' \
        prefix='$(PREFIX)/$(TARGET)' \
        SYS=mingw \
        -j '$(JOBS)' install
endef
