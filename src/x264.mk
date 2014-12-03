# This file is part of MXE.
# See index.html for further information.

PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20141130-2245
$(PKG)_CHECKSUM := e2a4f5dd0a773a3e89f7c5cf1b3d2efc95f282b8
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc yasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.videolan.org/?p=x264.git;a=shortlog' | \
    $(SED) -n 's,.*\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\).*,\1\2\3-2245,p' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,yasm,$(TARGET)-yasm,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --cross-prefix='$(TARGET)'- \
        --enable-win32thread \
        --disable-lavf \
        --disable-swscale   # Avoid circular dependency with ffmpeg. Remove if undesired.
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
