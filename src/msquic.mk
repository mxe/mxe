# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := msquic
$(PKG)_WEBSITE  := https://github.com/microsoft/msquic
$(PKG)_DESCR    := Microsoft implementation of the IETF QUIC protocol
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.6
$(PKG)_CHECKSUM := a010a5f8daa3a73623493e99ac09e7e5bbc783ad809904b5a23bfc41a4051550
$(PKG)_GH_CONF  := microsoft/msquic/tags, v
$(PKG)_DEPS     := cc quictls

define $(PKG)_BUILD
    # Disable MXE ccache wrapper for this package to avoid compiler mis-detection
    cd '$(BUILD_DIR)' && \
        $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DMXE_USE_CCACHE=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DQUIC_TLS_LIB=quictls \
        -DQUIC_USE_SYSTEM_LIBCRYPTO=ON \
        -DQUIC_BUILD_TOOLS=OFF \
        -DQUIC_BUILD_TEST=OFF \
        -DQUIC_BUILD_PERF=OFF \
        -DQUIC_ENABLE_LOGGING=OFF \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # Install headers manually if not installed by cmake
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/msquic'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/inc/msquic.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/inc/msquic_posix.h' '$(PREFIX)/$(TARGET)/include/' 2>/dev/null || true
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/inc/msquic_winuser.h' '$(PREFIX)/$(TARGET)/include/' 2>/dev/null || true
    $(INSTALL) -m644 '$(SOURCE_DIR)/src/inc/quic_sal_stub.h' '$(PREFIX)/$(TARGET)/include/' 2>/dev/null || true

    # Create pkg-config file
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'prefix=$(PREFIX)/$(TARGET)'; \
     echo 'exec_prefix=$${prefix}'; \
     echo 'libdir=$${exec_prefix}/lib'; \
     echo 'includedir=$${prefix}/include'; \
     echo ''; \
     echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $($(PKG)_DESCR)'; \
     echo 'Libs: -L$${libdir} -lmsquic'; \
     echo 'Libs.private: -lws2_32 -liphlpapi -lbcrypt -lncrypt -lcrypt32 -ladvapi32 -lwinmm -lntdll'; \
     echo 'Cflags: -I$${includedir}'; \
     echo 'Requires: libssl libcrypto') \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/msquic.pc'

    # Build test program
    '$(PREFIX)/bin/$(TARGET)-gcc' \
        -W -Wall -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
endef
