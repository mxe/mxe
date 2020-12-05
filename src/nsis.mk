# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nsis
$(PKG)_WEBSITE  := https://nsis.sourceforge.io/
$(PKG)_DESCR    := NSIS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.06.1
$(PKG)_CHECKSUM := 9b5d68bf1874a7b393432410c7e8c376f174d2602179883845d2508152153ff0
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 3/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc scons-local

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://nsis.sourceforge.io/Download' | \
    $(SED) -n 's,.*nsis-\([0-9.]\+\)-src.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_SCONS_OPTS
    XGCC_W32_PREFIX='$(TARGET)-' \
    PREFIX='$(PREFIX)/$(TARGET)' \
    `[ -d /usr/local/include ] && echo APPEND_CPPPATH=/usr/local/include` \
    `[ -d /usr/local/lib ]     && echo APPEND_LIBPATH=/usr/local/lib` \
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        SKIPPLUGINS='System' TARGET_ARCH=amd64) \
    SKIPUTILS='MakeLangId,Makensisw,NSIS Menu,zip2exe' \
    NSIS_MAX_STRLEN=8192
endef

define $(PKG)_BUILD
    # scons supports -j option but nsis parallel build fails
    # nsis uses it's own BUILD_PREFIX which isn't user configurable
    $(SCONS_PREP)
    $(if $(findstring x86_64-w64-mingw32,$(TARGET)),\
        $(SED) -i 's/pei-i386/pei-x86-64/' '$(1)/SCons/Config/linker_script' && \
        $(SED) -i 's/m_target_type=TARGET_X86ANSI/m_target_type=TARGET_AMD64/' '$(SOURCE_DIR)/Source/build.cpp')

    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j '$(JOBS)' -k || \
    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j '$(JOBS)'
    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j 1 install

    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/makensis' '$(PREFIX)/bin/$(TARGET)-makensis'
    '$(TARGET)-makensis' '$(SOURCE_DIR)/Examples/bigtest.nsi'
    $(INSTALL) -m755 '$(SOURCE_DIR)/Examples/bigtest.exe' '$(PREFIX)/$(TARGET)/bin/test-nsis.exe'
endef
