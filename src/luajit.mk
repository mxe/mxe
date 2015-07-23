# This file is part of MXE.
# See index.html for further information.

PKG             := luajit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.4
$(PKG)_CHECKSUM := 6e533675180300e85d12c4bbeea2d0e41ad21172
$(PKG)_SUBDIR   := LuaJIT-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://luajit.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc dlfcn-win32

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        HOST_CC='gcc -m$(BITS)' CROSS='$(TARGET)-' \
        TARGET_SYS=Windows BUILDMODE=static \
        PREFIX='$(PREFIX)/$(TARGET)' \
        FILE_T=luajit.exe \
        install
endef

# gcc -m64 is only available on 64-bit machines
ifeq (,$(findstring 64,$(BUILD)))
    $(PKG)_BUILD_x86_64-w64-mingw32 =
endif

$(PKG)_BUILD_SHARED =
