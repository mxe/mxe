# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := unrtf
$(PKG)_WEBSITE  := https://www.gnu.org/software/unrtf/
$(PKG)_DESCR    := unRTF
$(PKG)_VERSION  := 0.21.14
$(PKG)_CHECKSUM := b1f72e87f195bd50dbc974b800918df61c881706c11716b7bd0a1981e81b9587
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
