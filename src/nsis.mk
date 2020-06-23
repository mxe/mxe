# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nsis
$(PKG)_WEBSITE  := https://nsis.sourceforge.io/
$(PKG)_DESCR    := NSIS
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.05
$(PKG)_CHECKSUM := b6e1b309ab907086c6797618ab2879cb95387ec144dab36656b0b5fb77e97ce9
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
    CCACHE_DISABLE=1 \
    PATH='$(PREFIX)/bin:$(PATH)' \
    PREFIX='$(PREFIX)/$(TARGET)' \
    XGCC_W32_PREFIX='$(TARGET)-' \
    APPEND_CPPPATH="['$(PREFIX)/$(TARGET)/include'$(shell [ -d /usr/local/include ] && echo , \'/usr/local/include\')]" \
    APPEND_LIBPATH="['$(PREFIX)/$(TARGET)/lib'$(shell [ -d /usr/local/lib ] && echo , \'/usr/local/lib\')]" \
    TARGET_ARCH=$(if $(findstring x86_64,$(TARGET)),amd64,x86) \
    TARGET_OS='windows' \
    SKIPUTILS='MakeLangId,Makensisw,NSIS Menu,zip2exe' \
    NSIS_MAX_STRLEN=8192 \
    LINKFLAGS="--oformat pei-$(if $(findstring x86_64,$(TARGET)),x86-64,i386)"
endef

define $(PKG)_BUILD
    # scons supports -j option but nsis parallel build fails
    # nsis uses it's own BUILD_PREFIX which isn't user configurable
    mkdir -p '$(BUILD_DIR).scons'
    $(call PREPARE_PKG_SOURCE,scons-local,'$(BUILD_DIR).scons')
    $(SED) -i 's/m_target_type=TARGET_X86ANSI/$(if $(findstring x86_64-w64,$(TARGET)), \
        m_target_type=TARGET_AMD64/,m_target_type=TARGET_X86UNICODE/)' \
        '$(SOURCE_DIR)/Source/build.cpp'
    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j '$(JOBS)' -k || \
    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j '$(JOBS)'
    cd '$(SOURCE_DIR)' && $(SCONS_LOCAL) $($(PKG)_SCONS_OPTS) -j 1 install

    $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/bin/makensis' '$(PREFIX)/bin/$(TARGET)-makensis'
    '$(TARGET)-makensis' '$(SOURCE_DIR)/Examples/bigtest.nsi'
    $(INSTALL) -m755 '$(SOURCE_DIR)/Examples/bigtest.exe' '$(PREFIX)/$(TARGET)/bin/test-nsis.exe'
endef
