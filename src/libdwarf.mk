PKG := libdwarf
$(PKG)_WEBSITE  := https://www.prevanders.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.2
$(PKG)_CHECKSUM := 22b66d06831a76f6a062126cdcad3fcc58540b89a1acb23c99f8861f50999ec3
$(PKG)_SUBDIR   := libdwarf-$($(PKG)_VERSION)
$(PKG)_FILE     := libdwarf-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.prevanders.net/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper zlib zstd

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Dwerror=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
