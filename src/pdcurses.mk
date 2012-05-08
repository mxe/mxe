# This file is part of MXE.
# See index.html for further information.

PKG             := pdcurses
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e36684442a6171cc3a5165c8c49c70f67db7288c
$(PKG)_SUBDIR   := PDCurses-$($(PKG)_VERSION)
$(PKG)_FILE     := PDCurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/pdcurses/pdcurses/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/pdcurses/files/pdcurses/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,copy,cp,' '$(1)/win32/mingwin32.mak'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs -f '$(1)/win32/mingwin32.mak' \
        CC='$(TARGET)-gcc' \
        LIBEXE='$(TARGET)-ar' \
        DLL=N \
        PDCURSES_SRCDIR=. \
        WIDE=Y \
        UTF8=Y
    $(TARGET)-ranlib '$(1)/pdcurses.a' '$(1)/panel.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/curses.h' '$(1)/panel.h' '$(1)/term.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/pdcurses.a' '$(PREFIX)/$(TARGET)/lib/libpdcurses.a'
    $(INSTALL) -m644 '$(1)/panel.a'    '$(PREFIX)/$(TARGET)/lib/libpanel.a'
endef
