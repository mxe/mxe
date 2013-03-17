# This file is part of MXE.
# See index.html for further information.

PKG             := guile
$(PKG)_IGNORE   := 2.0.9
$(PKG)_CHECKSUM := 24cd2f06439c76d41d982a7384fe8a0fe5313b54
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libtool gmp libiconv gettext libunistring gc libffi readline libgnurx

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=$(PKG).git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>[^0-9>]*\([0-9][^< ]*\)\.<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # The setting "scm_cv_struct_timespec=no" ensures that Guile
    # won't try to use the "struct timespec" from <pthreads.h>,
    # which would fail because we tell Guile not to use Pthreads.
    cd '$(1)' && CC_FOR_BUILD=gcc ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --without-threads \
        scm_cv_struct_timespec=no \
        LIBS='-lunistring -lintl -liconv' \
        CFLAGS='-Wno-unused-but-set-variable'
    $(MAKE) -C '$(1)' -j '$(JOBS)' schemelib_DATA=
    $(MAKE) -C '$(1)' -j 1 install schemelib_DATA=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-guile.exe' \
        `'$(TARGET)-pkg-config' guile-$(call SHORT_PKG_VERSION,$(PKG)) --cflags --libs` \
        -DGUILE_MAJOR_MINOR=\"$(call SHORT_PKG_VERSION,$(PKG))\"
endef
