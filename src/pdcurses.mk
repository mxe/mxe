# This file is part of MXE.
# See index.html for further information.

PKG             := pdcurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4
$(PKG)_CHECKSUM := 46ad8fd439e71d44819ea884d775ccbf653b9f8b1f7a418a0cce3a510aa2e64b
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
    mv '$(1)/pdcurses.a' '$(1)/libcurses.a'
    mv '$(1)/panel.a'    '$(1)/libpanel.a'
    $(TARGET)-ranlib '$(1)/libcurses.a' '$(1)/libpanel.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/curses.h' '$(1)/panel.h' '$(1)/term.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/'
    $(if $(BUILD_STATIC), \
        $(INSTALL) -m644 '$(1)/libcurses.a' '$(1)/libpanel.a' '$(PREFIX)/$(TARGET)/lib/', \
        $(MAKE_SHARED_FROM_STATIC) '$(1)/libcurses.a' && \
        $(MAKE_SHARED_FROM_STATIC) '$(1)/libpanel.a' \
    )
endef
