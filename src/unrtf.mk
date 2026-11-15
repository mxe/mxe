# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := unrtf
$(PKG)_WEBSITE  := https://www.gnu.org/software/unrtf/
$(PKG)_DESCR    := unRTF
$(PKG)_VERSION  := 0.21.13
$(PKG)_CHECKSUM := ff227d1a0adb84a9e1a51b5e5c3cecbda3d67c8a31dbd7e8593a040a438fb44c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.gnu.org/software/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv

define $(PKG)_UPDATE
    $(call GET_LATEST_VERSION, https://ftp.gnu.org/gnu/unrtf/)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS='-Wno-discarded-qualifiers -Wno-implicit-function-declaration' \
        LIBS='-liconv -lshlwapi -lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
