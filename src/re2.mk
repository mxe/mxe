# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := re2
$(PKG)_DESCR    := RE2 regex library
$(PKG)_WEBSITE  := https://github.com/google/re2/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2020-08-01
$(PKG)_CHECKSUM := 6f4c8514249cd65b9e85d3e6f4c35595809a63ad71c5d93083e4d1dcdf9e0cd6
$(PKG)_GH_CONF  := google/re2/releases/latest
$(PKG)_SUBDIR   := re2-$($(PKG)_VERSION)
$(PKG)_FILE     := re2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/re2/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc icu4c

define $(PKG)_BUILD
    $(MAKE) $(MXE_DISABLE_CRUFT) \
        -C '$(SOURCE_DIR)' \
        -j '$(JOBS)' \
	CXX=$(TARGET)-g++ \
	AR=$(TARGET)-ar \
	NM=$(TARGET)-nm \
	prefix=$(PREFIX)/$(TARGET) \
	static

    $(MAKE) $(MXE_DISABLE_CRUFT) \
        -C '$(SOURCE_DIR)' \
        -j 1 \
	prefix=$(PREFIX)/$(TARGET) \
	static-install

    # compile test
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' re2 --cflags --libs`
endef
