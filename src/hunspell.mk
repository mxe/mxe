# This file is part of MXE.
# See index.html for further information.

PKG             := hunspell
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 902c76d2b55a22610e2227abc4fd26cbe606a51c
$(PKG)_SUBDIR   := hunspell-$($(PKG)_VERSION)
$(PKG)_FILE     := hunspell-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/hunspell/Hunspell/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gettext readline pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/hunspell/files/Hunspell/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Note: the configure file doesn't pick up pdcurses, so "ui" is disabled
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --with-warnings \
        --without-ui \
        --with-readline \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=


    # Test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cxx' -o '$(PREFIX)/$(TARGET)/bin/test-hunspell.exe' \
        `'$(TARGET)-pkg-config' hunspell --cflags --libs`
    # Install dummy dictionary needed by the test program
    $(INSTALL) -m644 -t '$(PREFIX)/$(TARGET)/bin' '$(TOP_DIR)/src/hunspell-test.aff' '$(TOP_DIR)/src/hunspell-test.dic'
endef
