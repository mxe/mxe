# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := vmime
$(PKG)_WEBSITE  := https://www.vmime.org/
$(PKG)_DESCR    := VMime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 54c50ae
$(PKG)_CHECKSUM := f2c6344514e5b0a4762c5b314abbf0285e79d46b54d9df4952224ed5bc817d3c
$(PKG)_GH_CONF  := kisli/vmime/branches/master
$(PKG)_DEPS     := cc gnutls libgsasl libiconv pthreads zlib

define $(PKG)_BUILD
    # The following hint is probably needed for ICU:
    # -DICU_LIBRARIES="`'$(TARGET)-pkg-config' --libs-only-l icu-i18n`"

    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -DCMAKE_CXX_FLAGS='-D_POSIX_C_SOURCE $(if $(BUILD_STATIC),-DGNUTLS_INTERNAL_BUILD,)' \
        -DCMAKE_AR='$(PREFIX)/bin/$(TARGET)-ar' \
        -DCMAKE_RANLIB='$(PREFIX)/bin/$(TARGET)-ranlib' \
        -DVMIME_HAVE_MESSAGING_PROTO_SENDMAIL=False \
        -DVMIME_HAVE_MLANG_H=False \
        -DVMIME_BUILD_STATIC_LIBRARY=$(CMAKE_STATIC_BOOL) \
        -DVMIME_BUILD_SHARED_LIBRARY=$(CMAKE_SHARED_BOOL) \
        -DVMIME_BUILD_{DOCUMENTATION,SAMPLES,TESTS}=OFF \
        -DCMAKE_MODULE_PATH='$(1)/cmake' \
        -DVMIME_CHARSETCONV_LIB=iconv \
        -DVMIME_TLS_SUPPORT_LIB=gnutls \
        -C '$(PWD)/src/vmime-TryRunResults.cmake'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
    $(SED) -i 's,^\(Libs.private:.* \)$(PREFIX)/$(TARGET)/lib/libiconv\.a,\1-liconv,g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/vmime.pc'
    $(if $(BUILD_STATIC),$(SED) -i 's/^\(Cflags:.* \)/\1 -DVMIME_STATIC /g' '$(PREFIX)/$(TARGET)/lib/pkgconfig/vmime.pc')

    $(SED) -i 's/posix/windows/g;' '$(SOURCE_DIR)/examples/example6.cpp'
    $(TARGET)-g++ -s -std=c++0x -o '$(PREFIX)/$(TARGET)/bin/test-vmime.exe' \
        '$(SOURCE_DIR)/examples/example6.cpp' \
        `'$(TARGET)-pkg-config' vmime --cflags --libs`
endef
