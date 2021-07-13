# This file is part of MXE.
# See index.html for further information.

PKG             := npp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.2.3
$(PKG)_CHECKSUM := e246ebb89c10b71ed483b866ea90385a661092e6
$(PKG)_SUBDIR   := unicode
$(PKG)_FILE     := $(PKG).$($(PKG)_VERSION).bin.zip
$(PKG)_URL      := http://download.tuxfamily.org/notepadplus/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package Notepad++.' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    #NOTEPAD_BASE_DIR := "$(PREFIX)/../notepad++/"
    mkdir -p '$(PREFIX)/notepad++'
    cd '$(1)' && tar cf - . | ( cd '$(PREFIX)/notepad++'; tar xpf - )
endef
