# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := xz
$(PKG)_WEBSITE  := https://tukaani.org/xz/
$(PKG)_DESCR    := XZ
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.8.4
$(PKG)_CHECKSUM := 0014c7886930454fe8bd4228665b51af55eeae560ea135c9c4cd33f55b2591d9
$(PKG)_GH_CONF  := tukaani-project/xz/releases,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B $(BUILD_DIR) \
        -DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
        -DXZ_THREADS=no \
        -DXZ_{DOC,NLS}=OFF \
        $(PKG_CMAKE_OPTS)
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' --parallel '$(JOBS)' --verbose
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
