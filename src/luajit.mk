# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := luajit
$(PKG)_WEBSITE  := https://luajit.org/luajit.html
$(PKG)_DESCR    := LuaJIT
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.5
$(PKG)_ABIVER   := 5.1
$(PKG)_DLLNAME  := $(PKG)$(subst .,,$($(PKG)_ABIVER)).dll
$(PKG)_CHECKSUM := 874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979
$(PKG)_SUBDIR   := LuaJIT-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://luajit.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc dlfcn-win32
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_BUILD
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' \
        HOST_CC='$(BUILD_CC) -m$(BITS)' \
        CROSS='$(TARGET)-' \
        TARGET_SYS=Windows \
        BUILDMODE=$(if $(BUILD_STATIC),static,dynamic) \
        PREFIX='$(PREFIX)/$(TARGET)' \
        TARGET_DLLNAME=$($(PKG)_DLLNAME) \
        FILE_T=luajit.exe \
        INSTALL_TNAME=luajit-$($(PKG)_VERSION).exe \
        INSTALL_TSYMNAME=luajit.exe \
        Q= \
        install
    $(if $(BUILD_SHARED),\
        $(INSTALL) -m644 '$(SOURCE_DIR)/src/$($(PKG)_DLLNAME)' '$(PREFIX)/$(TARGET)/bin/')
endef

define $(PKG)_BUILD_$(BUILD)
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)' \
        BUILDMODE=static \
        PREFIX='$(PREFIX)/$(BUILD)' \
        install
endef

# gcc -m64 is only available on 64-bit machines
ifeq (,$(findstring 64,$(BUILD)))
    $(PKG)_BUILD_x86_64-w64-mingw32 =
endif

# darwin no longer supports multi-lib
ifeq ($(findstring x86_64-apple-darwin,$(BUILD)),x86_64-apple-darwin)
    $(PKG)_BUILD_i686-w64-mingw32 =
endif
