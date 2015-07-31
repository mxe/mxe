# This file is part of MXE.
# See index.html for further information.

PKG             := aspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.60.6.1
$(PKG)_CHECKSUM := ff1190db8de279f950c242c6f4c5d5cdc2cbdc49
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/aspell/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-win32-relocatable \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
