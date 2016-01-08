# This file is part of MXE.
# See index.html for further information.

PKG             := hunspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := a7b2c0de0e2ce17426821dc1ac8eb115029959b3ada9d80a81739fa19373246c
$(PKG)_SUBDIR   := hunspell-$($(PKG)_VERSION)
$(PKG)_FILE     := hunspell-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/hunspell/Hunspell/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gettext libiconv pthreads readline

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/hunspell/files/Hunspell/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Note: the configure file doesn't pick up pdcurses, so "ui" is disabled
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-warnings \
        --without-ui \
        --with-readline
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    # Test
    '$(TARGET)-g++' \
        -W -Wall -Werror -std=c++0x -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-hunspell.exe' \
        `'$(TARGET)-pkg-config' hunspell --cflags --libs`
endef
