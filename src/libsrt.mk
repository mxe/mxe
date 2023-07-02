# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsrt
$(PKG)_WEBSITE  := https://github.com/Haivision/srt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 463970a3f575446b3f55abb6f323d5476c963c77b3c975cd902e9c87cdd9a92c
$(PKG)_GH_CONF  := Haivision/srt/tags, v
$(PKG)_DEPS     := cc pthreads openssl

define $(PKG)_BUILD_STATIC
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' -DUSE_STATIC_LIBSTDCXX=ON -DIFNEEDED_SRT_LDFLAGS=-lstdc++ -DENABLE_STATIC=ON -DENABLE_SHARED=OFF -DENABLE_EXAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef

define $(PKG)_BUILD_SHARED
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' -DENABLE_EXAMPLES=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT)
endef
