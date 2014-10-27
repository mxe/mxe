# This file is part of MXE.
# See index.html for further information.

PKG             := luajit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 2db39e7d1264918c2266b0436c313fbd12da4ceb
$(PKG)_SUBDIR   := LuaJIT-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://luajit.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        HOST_CC='gcc -m32' CROSS='$(TARGET)-' \
        TARGET_SYS=Windows BUILDMODE=static \
        PREFIX='$(PREFIX)/$(TARGET)' \
        FILE_T=luajit.exe \
        install
endef

# gcc -m64 is only available on 64-bit machines
ifneq (,$(findstring 64,$(BUILD)))
    $(PKG)_BUILD_x86_64-w64-mingw32 = \
        $(subst 'gcc -m32','gcc -m64',$($(PKG)_BUILD))
else
    $(PKG)_BUILD_x86_64-w64-mingw32 =
endif

$(PKG)_BUILD_SHARED =
