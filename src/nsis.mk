# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nsis
$(PKG)_WEBSITE  := https://nsis.sourceforge.io/
$(PKG)_DESCR    := NSIS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.01
$(PKG)_CHECKSUM := 604c011593be484e65b2141c50a018f1b28ab28c994268e4ecd377773f3ffba1
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 3/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://nsis.sourceforge.io/Download' | \
    $(SED) -n 's,.*nsis-\([0-9.]\+\)-src.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        $(SED) -i 's/pei-i386/pei-x86-64/' '$(1)/SCons/Config/linker_script')
    cd '$(1)' && scons \
        MINGW_CROSS_PREFIX='$(TARGET)-' \
        PREFIX='$(PREFIX)/$(TARGET)' \
        `[ -d /usr/local/include ] && echo APPEND_CPPPATH=/usr/local/include` \
        `[ -d /usr/local/lib ]     && echo APPEND_LIBPATH=/usr/local/lib` \
        $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
            SKIPPLUGINS='System') \
        SKIPUTILS='MakeLangId,Makensisw,NSIS Menu,zip2exe' \
        NSIS_MAX_STRLEN=8192 \
        install
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/makensis' '$(PREFIX)/bin/$(TARGET)-makensis'
endef
