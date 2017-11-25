# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsamplerate
$(PKG)_WEBSITE  := http://www.mega-nerd.com/SRC/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.9
$(PKG)_CHECKSUM := 0a7eb168e2f21353fb6d84da152e4512126f7dc48ccb0be80578c565413444c1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mega-nerd.com/SRC/$(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mega-nerd.com/SRC/download.html' | \
    $(SED) -n 's,.*$(PKG)-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # fftw and sndfile are only used for tests/examples
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-fftw \
        --disable-sndfile
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS) $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS) $(MXE_DISABLE_DOCS)
endef
