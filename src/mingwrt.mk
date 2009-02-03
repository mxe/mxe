# MinGW Runtime
# http://mingw.sourceforge.net/

PKG            := mingwrt
$(PKG)_VERSION := 3.15.1-mingw32
$(PKG)_SUBDIR  := .
$(PKG)_FILE    := mingwrt-$($(PKG)_VERSION)-dev.tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=11598' | \
    grep 'mingwrt-' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^>]*\)-dev\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    install -d '$(PREFIX)/$(TARGET)'
    cd '$(1)' && \
        cp -rpv include lib '$(PREFIX)/$(TARGET)'
endef
