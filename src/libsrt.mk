# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libsrt
$(PKG)_WEBSITE  := https://github.com/Haivision/srt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.4
$(PKG)_CHECKSUM := 93f5f3715bd5bd522b8d65fc0d086ef2ad49db6a41ad2d7b35df2e8bd7094114
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
