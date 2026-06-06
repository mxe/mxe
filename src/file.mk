# CHECKED #
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := file
$(PKG)_WEBSITE  := https://www.darwinsys.com/file/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.47
$(PKG)_CHECKSUM := 45672fec165cb4cc1358a2d76b5d57d22876dcb97ab169427ac385cbe1d5597a
$(PKG)_SUBDIR   := file-$($(PKG)_VERSION)
$(PKG)_FILE     := file-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://astron.com/pub/file/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/file/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgnurx $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://astron.com/pub/file/' | \
    grep 'file-' | \
    $(SED) -n 's,.*file-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(if $(BUILD_CROSS), \
            $(MXE_CONFIGURE_OPTS) \
            CFLAGS='-std=gnu99 -Wno-error=incompatible-pointer-types' \
            WARNINGS= \
        , \
            --prefix='$(PREFIX)/$(TARGET)' \
            --disable-shared \
        )

    $(if $(BUILD_CROSS), \
        $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= FILE_COMPILE='$(PREFIX)/$(BUILD)/bin/file' \
        && $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= \
        && '$(TARGET)-gcc' \
            -W -Wall -Werror -ansi -pedantic \
            '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-file.exe' \
            -lmagic -lgnurx -lshlwapi \
    , \
        $(MAKE) -C '$(1)' -j '$(JOBS)' \
        && $(MAKE) -C '$(1)' -j 1 install \
    )
endef
