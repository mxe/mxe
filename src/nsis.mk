# This file is part of MXE.
# See index.html for further information.

PKG             := nsis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.50
$(PKG)_CHECKSUM := 3fb674cb75e0237ef6b7c9e8a8e8ce89504087a6932c5d2e26764d4220a89848
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 2/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://nsis.sourceforge.net/Download' | \
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
        SKIPUTILS='NSIS Menu' \
        NSIS_MAX_STRLEN=8192 \
        install
    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/makensis' '$(PREFIX)/bin/$(TARGET)-makensis'
endef
