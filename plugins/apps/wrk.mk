# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := wrk
$(PKG)_WEBSITE  := https://github.com/wg/wrk
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.1
$(PKG)_CHECKSUM := c03bbc283836cb4b706eb6bfd18e724a8ce475e2c16154c13c6323a845b4327d
$(PKG)_GH_CONF  := wg/wrk/tags
$(PKG)_DEPS     := cc luajit openssl pthreads $(BUILD)~luajit

define $(PKG)_BUILD
    $(MAKE) \
        -C '$(1)' \
        -j '$(JOBS)' \
        CC='$(TARGET)-gcc' \
        TARGET='mingw' \
        LUAJIT='$(PREFIX)/$(BUILD)/bin/luajit' \
        LUA_PATH='$(PREFIX)/$(BUILD)/share/luajit-$(luajit_VERSION)/?.lua' \
        LUAJIT_A='$(PREFIX)/$(TARGET)/lib/libluajit-$(luajit_ABIVER).a' \
        LUAJIT_I='$(PREFIX)/$(TARGET)/include/luajit-$(call SHORT_PKG_VERSION,luajit)/' \
        EXTRA_LIBS='-lz -lws2_32 -lgdi32' \
        BIN='wrk.exe'
    cp '$(1)/wrk.exe' '$(PREFIX)/$(TARGET)/bin/'
endef

$(PKG)_BUILD_SHARED =
