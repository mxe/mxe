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
    $(SED) 's,copy,cp,' -i '$(2)/win32/mingwin32.mak'
    $(MAKE) -C '$(2)' -j '$(JOBS)' libs -f '$(2)/win32/mingwin32.mak' \
        CC='$(TARGET)-gcc' \
        LIBEXE='$(TARGET)-ar' \
        DLL=N \
        PDCURSES_SRCDIR=. \
        WIDE=Y \
        UTF8=Y
    $(TARGET)-ranlib '$(2)/pdcurses.a' '$(2)/panel.a'
    install -d '$(PREFIX)/$(TARGET)/include/'
    install -m644 '$(2)/curses.h' '$(2)/panel.h' '$(2)/term.h' '$(PREFIX)/$(TARGET)/include/'
    install -d '$(PREFIX)/$(TARGET)/lib/'
    install -m644 '$(2)/pdcurses.a' '$(PREFIX)/$(TARGET)/lib/libpdcurses.a'
    install -m644 '$(2)/panel.a'    '$(PREFIX)/$(TARGET)/lib/libpanel.a'
endef
