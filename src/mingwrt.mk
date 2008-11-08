# MinGW Runtime
# http://mingw.sourceforge.net/

PKG            := mingwrt
$(PKG)_VERSION := 3.14
$(PKG)_SUBDIR  := .
$(PKG)_FILE    := mingw-runtime-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := http://$(SOURCEFORGE_MIRROR)/mingw/$($(PKG)_FILE)
$(PKG)_DEPS    :=

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/project/showfiles.php?group_id=2435&package_id=11598' | \
    $(SED) -n 's,.*mingwrt-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir -p '$(PREFIX)/$(TARGET)'
    cd '$(2)' && \
        cp -rpv bin include lib '$(PREFIX)/$(TARGET)'
endef
