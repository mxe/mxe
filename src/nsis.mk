# NSIS

PKG             := nsis
$(PKG)_VERSION  := 2.44
$(PKG)_CHECKSUM := 07db4bcbbba7b66b4e1553c2d6ea42ed8eaab66a
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_WEBSITE  := http://nsis.sourceforge.net/
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/nsis/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://nsis.sourceforge.net/Download' | \
    grep 'nsis-' | \
    $(SED) -n 's,.*nsis-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && scons PREFIX='$(PREFIX)' install
endef
