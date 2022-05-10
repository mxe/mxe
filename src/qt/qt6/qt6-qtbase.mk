# This file is part of MXE. See LICENSE.md for licensing information.

PKG_BASENAME    := qtbase
PKG             := qt6-$(PKG_BASENAME)
$(PKG)_WEBSITE  := https://www.qt.io/
$(PKG)_DESCR    := Qt6
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.3.0
$(PKG)_CHECKSUM := b865aae43357f792b3b0a162899d9bf6a1393a55c4e5e4ede5316b157b1a0f99
$(PKG)_SUBDIR   := $(PKG_BASENAME)-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG_BASENAME)-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/official_releases/qt/6.3/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS     := cc freetype harfbuzz jpeg libpng mesa pcre2 sqlite zlib zstd $(BUILD)~$(PKG) \
                   $(if $(findstring shared,$(MXE_TARGETS)), icu4c)
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_OO_DEPS_$(BUILD) := ninja

define $(PKG)_UPDATE
    $(WGET) -q -O- https://download.qt.io/official_releases/qt/6.3/ | \
    $(SED) -n 's,.*href="\(6\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    rm -rf '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
    # review $(SOURCE_DIR)/cmake/configure-cmake-mapping.md
    PKG_CONFIG="${TARGET}-pkg-config" \
    PKG_CONFIG_SYSROOT_DIR="/" \
    PKG_CONFIG_LIBDIR="$(PREFIX)/$(TARGET)/lib/pkgconfig" \
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)' \
        -DQT_HOST_PATH='$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)' \
        -DQT_QMAKE_DEVICE_OPTIONS='CROSS_COMPILE=$(TARGET)-;PKG_CONFIG=$(TARGET)-pkg-config' \
        -DPKG_CONFIG_EXECUTABLE='$(PREFIX)/bin/$(TARGET)-pkg-config' \
        -DQT_QMAKE_TARGET_MKSPEC=win32-g++ \
        -DQT_BUILD_EXAMPLES=OFF \
        -DQT_BUILD_TESTS=OFF \
        -DBUILD_WITH_PCH=OFF \
        -DFEATURE_accessibility=ON \
        -DFEATURE_dbus=OFF \
        -DFEATURE_fontconfig=OFF \
        -DFEATURE_system_freetype=ON \
        -DFEATURE_glib=OFF \
        -DFEATURE_system_harfbuzz=ON \
        -DFEATURE_icu=$(CMAKE_SHARED_BOOL) \
        -DFEATURE_opengl_dynamic=ON \
        -DFEATURE_openssl=OFF \
        -DFEATURE_system_pcre2=ON \
        -DFEATURE_pkg_config=ON \
        -DFEATURE_sql_mysql=OFF \
        -DFEATURE_sql_odbc=ON \
        -DFEATURE_sql_psql=OFF \
        -DFEATURE_system_sqlite=ON \
        -DFEATURE_system_zlib=ON \
        -DFEATURE_use_gold_linker_alias=OFF \
        $(PKG_CMAKE_OPTS)

    cmake --build '$(BUILD_DIR)' -j '$(JOBS)'
    cmake --install '$(BUILD_DIR)'
    $(if $(BUILD_STATIC),$(SED) -i -e 's/^QMAKE_PRL_LIBS .*/& -lodbc32/;' \
	      -e 's/^QMAKE_PRL_LIBS_FOR_CMAKE .*/&;-lodbc32/;' \
              '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)/plugins/sqldrivers/qsqlodbc.prl',)

    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    echo 'set(QT_HOST_PATH "$(PREFIX)/$(BUILD)/$(MXE_QT6_ID)")' \
        > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'
endef

define $(PKG)_BUILD_$(BUILD)
    rm -rf '$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)'
    '$(TARGET)-cmake' -S '$(SOURCE_DIR)' -B '$(BUILD_DIR)' \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX='$(PREFIX)/$(TARGET)/$(MXE_QT6_ID)' \
        -DQT_BUILD_{TESTS,EXAMPLES}=OFF \
        -DFEATURE_{eventfd,glib,harfbuzz,icu,opengl,openssl}=OFF \
        -DFEATURE_sql_{db2,ibase,mysql,oci,odbc,psql,sqlite}=OFF
    '$(TARGET)-cmake' --build '$(BUILD_DIR)' -j '$(JOBS)'
    '$(TARGET)-cmake' --install '$(BUILD_DIR)'
endef
