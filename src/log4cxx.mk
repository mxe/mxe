# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := log4cxx
$(PKG)_WEBSITE  := https://logging.apache.org/log4cxx/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.0
$(PKG)_CHECKSUM := 0de0396220a9566a580166e66b39674cb40efd2176f52ad2c65486c99c920c8c
$(PKG)_SUBDIR   := apache-log4cxx-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://www.apache.org/dist/logging/log4cxx/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://archive.apache.org/dist/logging/log4cxx/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc apr-util

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://logging.apache.org/log4cxx/download.html' | \
    $(SED) -n 's,.*log4cxx-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # configure script is ancient and isn't easy to regenerate
    # filter out invalid options
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(subst docdir$(comma),,$(MXE_CONFIGURE_OPTS)) \
        --with-apr='$(PREFIX)/$(TARGET)' \
        --with-apr-util='$(PREFIX)/$(TARGET)' \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        CXXFLAGS=-D_WIN32_WINNT=0x0500

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_PROGRAMS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_PROGRAMS)

    mkdir -p '$(PREFIX)/$(TARGET)/share/cmake/log4cxx'
    cp '$(1)/log4cxx-config.cmake' '$(PREFIX)/$(TARGET)/share/cmake/log4cxx/log4cxx-config.cmake'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-log4cxx.exe' \
        `$(TARGET)-pkg-config liblog4cxx --libs`
endef

$(PKG)_BUILD_SHARED =
