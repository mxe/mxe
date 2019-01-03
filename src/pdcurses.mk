# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pdcurses
$(PKG)_WEBSITE  := https://pdcurses.sourceforge.io/
$(PKG)_DESCR    := PDcurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4
$(PKG)_CHECKSUM := 46ad8fd439e71d44819ea884d775ccbf653b9f8b1f7a418a0cce3a510aa2e64b
$(PKG)_SUBDIR   := PDCurses-$($(PKG)_VERSION)
$(PKG)_FILE     := PDCurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/pdcurses/pdcurses/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/pdcurses/files/pdcurses/' | \
    $(SED) -n 's,.*/projects/.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,copy,cp,' '$(SOURCE_DIR)/win32/mingwin32.mak'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' libs -f '$(SOURCE_DIR)/win32/mingwin32.mak' \
        CC='$(TARGET)-gcc' \
        LIBEXE='$(TARGET)-ar' \
        DLL=N \
        PDCURSES_SRCDIR='$(SOURCE_DIR)' \
        WIDE=Y \
        UTF8=Y
    $(TARGET)-ranlib '$(BUILD_DIR)/pdcurses.a' '$(BUILD_DIR)/panel.a'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(SOURCE_DIR)/curses.h' '$(SOURCE_DIR)/panel.h' '$(SOURCE_DIR)/term.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/'
    $(if $(BUILD_STATIC), \
        $(INSTALL) -m644 '$(BUILD_DIR)/pdcurses.a' '$(BUILD_DIR)/panel.a' '$(PREFIX)/$(TARGET)/lib/', \
        $(MAKE_SHARED_FROM_STATIC) '$(BUILD_DIR)/pdcurses.a' && \
        $(MAKE_SHARED_FROM_STATIC) '$(BUILD_DIR)/panel.a' \
    )
endef
