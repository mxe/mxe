# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsignal-protocol-c
$(PKG)_WEBSITE  := https://github.com/signalapp/libsignal-protocol-c
$(PKG)_DESCR    := libsignal-protocol-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9e10362
$(PKG)_CHECKSUM := 05a6161cca61e16679fe189039b3cdebe26ed7ee8414d59afdc60363f46fb8fe
$(PKG)_GH_CONF  := signalapp/libsignal-protocol-c/branches/master
$(PKG)_DEPS     := cc pthreads

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, signalapp/libsignal-protocol-c, master)

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install VERBOSE=1
endef
