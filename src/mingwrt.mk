# MinGW Runtime

PKG             := mingwrt
$(PKG)_VERSION  := 3.15.2-mingw32
$(PKG)_CHECKSUM := 9f562408b94202ecff558e683e5d7df5440612c4
$(PKG)_SUBDIR   := .
$(PKG)_FILE     := mingwrt-$($(PKG)_VERSION)-dev.tar.gz
$(PKG)_WEBSITE  := http://mingw.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/mingw/files/MinGW Runtime/) | \
    $(SED) -n 's,.*mingwrt-\([0-9][^>]*\)-dev\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
