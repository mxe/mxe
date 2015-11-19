# This file is part of MXE.
# See index.html for further information.

PKG             := dlfcn-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := a0077c1b2da06d6ffa665cf4b315b40d8633054fd8738c68309ff800e0c95ee3
$(PKG)_DEPS     := gcc

$(PKG)_GH_REPO    := $(PKG)/$(PKG)
$(PKG)_GH_TAG_PFX := v
$(PKG)_GH_TAG_SHA := cf56306
$(eval $(MXE_SETUP_GITHUB))

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --cross-prefix='$(TARGET)-' \
        $(if $(BUILD_STATIC), \
            --enable-static --disable-shared , \
            --disable-static --enable-shared )
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(MAKE) -C '$(1)' -j '$(JOBS)' test.exe testdll.dll
endef
