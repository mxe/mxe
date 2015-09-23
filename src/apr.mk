# This file is part of MXE.
# See index.html for further information.

PKG             := apr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 1af06e1720a58851d90694a984af18355b65bb0d047be03ec7d659c746d6dbdb
$(PKG)_SUBDIR   := apr-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://archive.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://apr.apache.org/download.cgi' | \
    grep 'apr1.*best' |
    $(SED) -n 's,.*APR \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    cp -Rp '$(1)' '$(1).native'
    cd '$(1).native' && ./configure
    cd '$(1).native' && $(MAKE) tools/gen_test_char \
        CFLAGS='-DNEED_ENHANCED_ESCAPES'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_sizeof_off_t=4 \
        ac_cv_sizeof_pid_t=4 \
        ac_cv_sizeof_size_t=4 \
        ac_cv_sizeof_ssize_t=4 \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j 1 install GEN_TEST_CHAR='$(1).native/tools/gen_test_char'

    ln -sf '$(PREFIX)/$(TARGET)/bin/apr-1-config' '$(PREFIX)/bin/$(TARGET)-apr-1-config'
endef
