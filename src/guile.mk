# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := guile
$(PKG)_WEBSITE  := https://www.gnu.org/software/guile/
$(PKG)_DESCR    := GNU Guile
$(PKG)_IGNORE   := 2%
$(PKG)_VERSION  := 1.8.8
$(PKG)_CHECKSUM := c3471fed2e72e5b04ad133bbaaf16369e8360283679bcf19800bc1b381024050
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gc gettext gmp libffi libgnurx libiconv libltdl libunistring readline

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnu.org/gnu/guile/' | \
    $(SED) -n 's,.*href="guile-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep '^1\.' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    # The setting "scm_cv_struct_timespec=no" ensures that Guile
    # won't try to use the "struct timespec" from <pthreads.h>,
    # which would fail because we tell Guile not to use Pthreads.
    cd '$(BUILD_DIR)' && CC_FOR_BUILD=$(BUILD_CC) $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS) \
        --without-threads \
        --without-64-calls \
        --disable-error-on-warning \
        scm_cv_struct_timespec=no \
        LIBS='-lunistring -lintl -liconv -ldl' \
        CFLAGS='-std=gnu89 -Wno-unused-but-set-variable -Wno-unused-value -Wno-incompatible-pointer-types -Wno-old-style-definition -Wno-implicit-function-declaration -Wno-attributes -Wno-int-conversion'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' $(MXE_DISABLE_CRUFT) schemelib_DATA=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install $(MXE_DISABLE_CRUFT) schemelib_DATA=

    '$(TARGET)-gcc' \
        -W -Wall \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-guile.exe' \
        `'$(TARGET)-pkg-config' guile-$(call SHORT_PKG_VERSION,$(PKG)) --cflags --libs` \
        -DGUILE_MAJOR_MINOR=\"$(call SHORT_PKG_VERSION,$(PKG))\"
endef

$(PKG)_BUILD_x86_64-w64-mingw32 =

$(PKG)_BUILD_SHARED =
