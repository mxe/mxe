# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# muParser
PKG             := muparser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.32
$(PKG)_CHECKSUM := ff9e7be4408cafbbd6d9256095eaf8ebb12611b1
$(PKG)_SUBDIR   := $(PKG)_v$(subst .,,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)_v$(subst .,,$($(PKG)_VERSION)).tar.gz
$(PKG)_WEBSITE  := http://muparser.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/muparser/muparser/Version%20$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/muparser/files/muparser/) | \
    $(SED) -n 's,/muparser/Version \([0-9.]*\)/muparser_v.*.tar.gz,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
