# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := poco
$(PKG)_WEBSITE  := https://pocoproject.org/
$(PKG)_DESCR    := POCO C++ Libraries
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.4
$(PKG)_CHECKSUM := 525591a43d4b5e9472663f8fa5fb9b7bfbd7ec8a0abe130ef7411531a0ea55c5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://pocoproject.org/releases/$(PKG)-$(word 1,$(subst p, ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc cmake-conf expat openssl pcre2 sqlite utf8proc zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://pocoproject.org/download/' | \
    $(SED) -n 's,.*poco-\([0-9][^>/]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DPOCO_UNBUNDLED=ON \
        -DPOCO_SQLITE_UNBUNDLED=ON \
        -DCMAKE_MC_COMPILER='$(TARGET)-windmc' \
        $(PKG_CMAKE_OPTS)
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --parallel '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'

    '$(TARGET)-g++' \
        -W -Wall -Werror -pedantic -DPOCO_STATIC=1  \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation -lpcre2-8
endef

$(PKG)_BUILD_SHARED =
