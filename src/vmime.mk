# This file is part of MXE.
# See index.html for further information.

PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := f3c9002
$(PKG)_CHECKSUM := 171ca701bf99cdc50316cadbe00583e0cad296f6
$(PKG)_SUBDIR   := kisli-vmime-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kisli/vmime/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gnutls libgsasl pthreads zlib

$(PKG)_UPDATE    = $(call MXE_GET_GITHUB_SHA, kisli/vmime, master)

define $(PKG)_BUILD
    # The following hint is probably needed for ICU:
    # -DICU_LIBRARIES="`'$(TARGET)-pkg-config' --libs-only-l icu-i18n`"

    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DVMIME_HAVE_MESSAGING_PROTO_SENDMAIL=False \
        -DVMIME_HAVE_MLANG_H=False \
        -DCMAKE_CXX_FLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        -DVMIME_BUILD_STATIC_LIBRARY=ON \
        -DVMIME_BUILD_SHARED_LIBRARY=OFF \
        -DVMIME_BUILD_SAMPLES=OFF \
        -DVMIME_BUILD_DOCUMENTATION=OFF \
        -DCMAKE_MODULE_PATH='$(1)/cmake' \
        -DVMIME_CHARSETCONV_LIB_IS_ICONV=OFF \
        -DVMIME_CHARSETCONV_LIB_IS_ICU=OFF \
        -DVMIME_CHARSETCONV_LIB_IS_WIN=ON \
        -DVMIME_TLS_SUPPORT_LIB_IS_GNUTLS=ON \
        -DVMIME_TLS_SUPPORT_LIB_IS_OPENSSL=OFF \
        -DVMIME_SHARED_PTR_USE_CXX=ON \
        -DCXX11_COMPILER_FLAGS=ON \
        -C../../src/vmime-TryRunResults.cmake \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(SED) -i 's,^\(Libs.private:.* \)$(PREFIX)/$(TARGET)/lib/libiconv\.a,\1-liconv,g' $(1)/vmime.pc
    $(MAKE) -C '$(1)' install

    $(SED) -i 's/posix/windows/g;' '$(1)/examples/example6.cpp'
    $(TARGET)-g++ -s -std=c++0x -o '$(1)/examples/test-vmime.exe' \
        '$(1)/examples/example6.cpp' \
        `'$(TARGET)-pkg-config' vmime --cflags --libs`
    $(INSTALL) -m755 '$(1)/examples/test-vmime.exe' '$(PREFIX)/$(TARGET)/bin/'
endef

$(PKG)_BUILD_SHARED =
