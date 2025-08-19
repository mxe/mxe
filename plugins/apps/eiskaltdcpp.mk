# This file is part of MXE.
# See index.html for further information.

PKG             := eiskaltdcpp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4c9cbf2
$(PKG)_CHECKSUM := a4c13aa0f507f10a74fbf9ef2ffd8838df893ae8ce38142bea83001104a46e6e
$(PKG)_GH_CONF  := eiskaltdcpp/eiskaltdcpp/work
$(PKG)_WEBSITE  := https://sourceforge.net/projects/eiskaltdcpp/
$(PKG)_OWNER    := https://github.com/pavelvat
$(PKG)_DEPS     := gcc aspell boost jsoncpp libidn lua miniupnpc nsis qtmultimedia qttools

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG) \
        -DSHARE_DIR=resources \
        -DDO_NOT_USE_MUTEX=ON \
        -DUSE_ASPELL=ON \
        -DFORCE_XDG=OFF \
        -DDBUS_NOTIFY=OFF \
        -DUSE_JS=OFF \
        -DWITH_EXAMPLES=OFF \
        -DUSE_MINIUPNP=ON \
        -DWITH_SOUNDS=ON \
        -DPERL_REGEX=ON \
        -DUSE_QT_QML=OFF \
        -DLUA_SCRIPT=ON \
        -DWITH_LUASCRIPTS=ON \
        -DUSE_QT_SQLITE=ON \
        -DNO_UI_DAEMON=ON \
        -DJSONRPC_DAEMON=ON \
        -DUSE_CLI_JSONRPC=ON \
        -DLOCAL_JSONCPP=OFF \
        -DSTATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    $(TARGET)-strip '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/eiskaltdcpp-qt.exe'
    $(TARGET)-strip '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/eiskaltdcpp-daemon.exe'
    $(INSTALL) '$(SOURCE_DIR)/windows/dcppboot.xml' '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)'
    $(INSTALL) '$(SOURCE_DIR)/eiskaltdcpp-cli/cli-jsonrpc-config.pl' '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/aspell/data/'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/aspell/dict/'
    $(INSTALL) $(PREFIX)/$(TARGET)/lib/aspell-0.60/* '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/aspell/data'
    $(if $(BUILD_SHARED),
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/audio';
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/platforms';
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/sqldrivers';
        $(INSTALL) '$(PREFIX)/$(TARGET)/qt5/plugins/audio/qtaudio_windows.dll' '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/audio';
        $(INSTALL) '$(PREFIX)/$(TARGET)/qt5/plugins/platforms/qwindows.dll'    '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/platforms';
        $(INSTALL) '$(PREFIX)/$(TARGET)/qt5/plugins/sqldrivers/qsqlite.dll'    '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/sqldrivers';

        '$(TOP_DIR)/tools/copydlldeps.sh' -c \
                                          -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)' \
                                          -F '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)' \
                                          -F '$(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/sqldrivers' \
                                          -X '$(PREFIX)/$(TARGET)/apps' \
                                          -R '$(PREFIX)/$(TARGET)';
     )
    $(INSTALL) -d '$(BUILD_DIR)/installer';
    cp -r $(PREFIX)/$(TARGET)/apps/$(PKG)/$(PKG)/* '$(BUILD_DIR)/installer';
    $(INSTALL) '$(SOURCE_DIR)/LICENSE' '$(BUILD_DIR)/installer';
    $(INSTALL) '$(SOURCE_DIR)/data/icons/eiskaltdcpp.ico' '$(BUILD_DIR)/installer';
    $(INSTALL) '$(SOURCE_DIR)/data/icons/icon_164x314.bmp' '$(BUILD_DIR)/installer';
    $(INSTALL) '$(SOURCE_DIR)/windows/EiskaltDC++.nsi' '$(BUILD_DIR)';
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/apps/$(PKG)/nsis';
    $(if $(BUILD_STATIC),
        $(if $(findstring x86_64,$(TARGET)),,
            $(TARGET)-makensis -Dstatic=32 '$(BUILD_DIR)/EiskaltDC++.nsi';
            $(INSTALL) '$(BUILD_DIR)/EiskaltDC++-2.4.0-x86-static.exe'    '$(PREFIX)/$(TARGET)/apps/$(PKG)/nsis'
         )
     )
    $(if $(BUILD_SHARED),
        $(if $(findstring x86_64,$(TARGET)),,
            $(TARGET)-makensis -Dshared=32 '$(BUILD_DIR)/EiskaltDC++.nsi';
            $(INSTALL) '$(BUILD_DIR)/EiskaltDC++-2.4.0-x86.exe'    '$(PREFIX)/$(TARGET)/apps/$(PKG)/nsis'
         )
     )
endef
