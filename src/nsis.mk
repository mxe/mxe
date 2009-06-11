# NSIS

PKG             := nsis
$(PKG)_VERSION  := 2.45
$(PKG)_CHECKSUM := ce02adf68dbedc798615ffb212d27a9b03d5defb
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_WEBSITE  := http://nsis.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/nsis/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://nsis.sourceforge.net/Download' | \
    grep 'nsis-' | \
    $(SED) -n 's,.*nsis-\([0-9][^>]*\)-src\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,this->SetIcon(wxICON(nsisicon));,,' -i '$(1)/Contrib/NSIS Menu/nsismenu/nsismenu.cpp'
    cd '$(1)' && scons \
        PREFIX='$(PREFIX)' \
        `[ -d /usr/local/include ] && echo APPEND_CPPPATH=/usr/local/include` \
        `[ -d /usr/local/lib ]     && echo APPEND_LIBPATH=/usr/local/lib` \
        SKIPUTILS='NSIS Menu' \
        install
endef
