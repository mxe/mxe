# This file is part of MXE.
# See index.html for further information.

PKG             := libdca
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := 3fa5188eaaa2fc83fb9c4196f6695a23cb17f3bc
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/videolan/libdca/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for libdca.' >&2;
    echo $(libdca_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libdca.exe' \
        `'$(TARGET)-pkg-config' libdca --cflags --libs`
endef
