# This file is part of MXE.
# See index.html for further information.

PKG             := wxmathplot
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.2
$(PKG)_CHECKSUM := 24be41c1ce3b5683561c380d518260c89ffc392c
$(PKG)_SUBDIR   := wxMathPlot-$($(PKG)_VERSION)
$(PKG)_FILE     := wxMathPlot-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/wxmathplot/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc wxwidgets

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/wxmathplot/files/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. 

    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
endef
