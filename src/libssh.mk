# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libssh
$(PKG)_WEBSITE  := https://www.libssh.org
$(PKG)_DESCR    := SSHv2 and SSHv1 protocol on client and server side
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.12.2
$(PKG)_CHECKSUM := 49560f677d96e3706a904ac2de1116e25f3680937d51e5c92198fcba4a1c1e9f
$(PKG)_SUBDIR   := libssh-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://www.libssh.org/files/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libgcrypt zlib

$(PKG)_EXTRA_WARNINGS := \
    -Wno-implicit-fallthrough

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
     echo 'Libs.private: -liphlpapi -lws2_32'; \
     echo 'Cflags.private: -DLIBSSH_STATIC';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -pedantic -std=c99 $($(PKG)_EXTRA_WARNINGS) \
        $(SOURCE_DIR)/examples/{authentication.c,knownhosts.c,connect_ssh.c,exec.c} \
        -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
