# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := apr
$(PKG)_WEBSITE  := https://apr.apache.org/
$(PKG)_DESCR    := APR
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5.2
$(PKG)_CHECKSUM := 1af06e1720a58851d90694a984af18355b65bb0d047be03ec7d659c746d6dbdb
$(PKG)_SUBDIR   := apr-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://apr.apache.org/download.cgi' | \
    grep 'apr1.*best' |
    $(SED) -n 's,.*APR \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    # native build for gen_test_char
    mkdir '$(BUILD_DIR).native'
    cd '$(BUILD_DIR).native' && '$(SOURCE_DIR)/configure'
    $(MAKE) -C '$(BUILD_DIR).native' tools/gen_test_char \
        CFLAGS='-DNEED_ENHANCED_ESCAPES' -j '$(JOBS)'

    # cross build
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        ac_cv_sizeof_off_t=4 \
        ac_cv_sizeof_pid_t=4 \
        ac_cv_sizeof_size_t=4 \
        ac_cv_sizeof_ssize_t=4 \
        $(if $(POSIX_THREADS),apr_cv_mutex_robust_shared=yes) \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' GEN_TEST_CHAR='$(BUILD_DIR).native/tools/gen_test_char'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    ln -sf '$(PREFIX)/$(TARGET)/bin/apr-1-config' '$(PREFIX)/bin/$(TARGET)-apr-1-config'
endef
