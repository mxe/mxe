# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libssh
$(PKG)_WEBSITE  := https://www.libssh.org
$(PKG)_DESCR    := SSHv2 and SSHv1 protocol on client and server side
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7.5
$(PKG)_CHECKSUM := d275b1b3622c36efacfac748d5eecaf0e80349a551f72abb6ce5afa8c2e6b784
$(PKG)_SUBDIR   := libssh-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://git.libssh.org/projects/libssh.git/snapshot/libssh-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := cc libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.libssh.org/projects/libssh.git/refs/tags' | \
    $(SED) -n "s,.*>libssh-\([0-9]*\.[^<]*\)\.tar.*,\1,p" | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DWITH_STATIC_LIB=$(CMAKE_STATIC_BOOL) \
        -DWITH_SHARED_LIB=$(CMAKE_SHARED_BOOL) \
        -DWITH_BENCHMARKS=OFF \
        -DWITH_CLIENT_TESTING=OFF \
        -DWITH_DEBUG_CALLTRACE=OFF \
        -DWITH_DEBUG_CRYPTO=OFF \
        -DWITH_EXAMPLES=OFF \
        -DWITH_GCRYPT=ON \
        -DWITH_GSSAPI=OFF \
        -DWITH_INTERNAL_DOC=OFF \
        -DWITH_NACL=OFF \
        -DWITH_PCAP=OFF \
        -DWITH_SERVER=ON \
        -DWITH_SFTP=ON \
        -DWITH_SSH1=ON \
        -DWITH_TESTING=OFF \
        -DWITH_ZLIB=ON

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: libssh'; \
     echo 'Requires: libgcrypt zlib'; \
     echo 'Libs: -lssh'; \
     echo 'Libs.private: -lws2_32'; \
     echo 'Cflags.private: -DLIBSSH_STATIC';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic \
        $(SOURCE_DIR)/examples/{authentication.c,knownhosts.c,connect_ssh.c,exec.c} \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
