# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := unrtf
$(PKG)_WEBSITE  := https://www.gnu.org/software/unrtf/
$(PKG)_DESCR    := unRTF
$(PKG)_VERSION  := 0.21.11
$(PKG)_CHECKSUM := 22419496626cb92e96af0036636ae922f6360d9249142ac396bd400bcd812ecd
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.gnu.org/software/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://hg.savannah.gnu.org/hgweb/unrtf/tags' | \
    $(SED) -n "s,^release_,,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        CFLAGS='-Wno-discarded-qualifiers -Wno-implicit-function-declaration' \
        LIBS='-liconv -lshlwapi -lws2_32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
