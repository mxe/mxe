# This file is part of MXE.
# See index.html for further information.

PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 31de466bcefb9e18b770bbfc14b383b9ea1c9eed
$(PKG)_SUBDIR   := kisli-vmime-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kisli/vmime/tarball/$($(PKG)_VERSION)/$(PKG)_FILE
$(PKG)_DEPS     := gcc libiconv gnutls libgsasl pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/kisli/vmime/commits/master' | \
    $(SED) -n 's#.*<span class="sha">\([^<]\{7\}\)[^<]\{3\}<.*#\1#p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DVMIME_HAVE_MESSAGING_PROTO_SENDMAIL=False \
        -DCMAKE_CXX_FLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        -DVMIME_BUILD_STATIC_LIBRARY=ON \
        -DVMIME_BUILD_SHARED_LIBRARY=OFF \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(SED) -i 's,^\(Libs.private:.* \)$(PREFIX)/$(TARGET)/lib/libiconv\.a,\1-liconv,g' $(1)/vmime.pc
    $(MAKE) -C '$(1)' install

    $(SED) -i 's/posix/windows/g;' '$(1)/examples/example6.cpp'
    $(TARGET)-g++ -s -o '$(1)/examples/test-vmime.exe' \
        '$(1)/examples/example6.cpp' \
        `'$(TARGET)-pkg-config' vmime --cflags --libs`
    $(INSTALL) -m755 '$(1)/examples/test-vmime.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
