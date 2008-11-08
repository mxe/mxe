# PDcurses
# http://pdcurses.sourceforge.net/

PKG            := pdcurses
$(PKG)_VERSION := 3.3
$(PKG)_SUBDIR  := PDCurses-$($(PKG)_VERSION)
$(PKG)_FILE    := PDCurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/pdcurses/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=30480&package_id=22452' | \
    grep 'PDCurses-' | \
    $(SED) -n 's,.*PDCurses-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,copy,cp,' -i '$(1)/win32/mingwin32.mak'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs -f '$(1)/win32/mingwin32.mak' \
        CC='$(TARGET)-gcc' \
        LIBEXE='$(TARGET)-ar' \
        DLL=N \
        PDCURSES_SRCDIR=. \
        WIDE=Y \
        UTF8=Y
    $(TARGET)-ranlib '$(1)/pdcurses.a' '$(1)/panel.a'
    install -d '$(PREFIX)/$(TARGET)/include/'
    install -m644 '$(1)/curses.h' '$(1)/panel.h' '$(1)/term.h' '$(PREFIX)/$(TARGET)/include/'
    install -d '$(PREFIX)/$(TARGET)/lib/'
    install -m644 '$(1)/pdcurses.a' '$(PREFIX)/$(TARGET)/lib/libpdcurses.a'
    install -m644 '$(1)/panel.a'    '$(PREFIX)/$(TARGET)/lib/libpanel.a'
endef
