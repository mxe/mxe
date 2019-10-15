# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtwebkit
$(PKG)_WEBSITE  := https://github.com/annulen/webkit
$(PKG)_DESCR    := QtWebKit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.13.1
$(PKG)_CHECKSUM := f688e039e2bdc06e2e46680f3ef57715e1b7d6ea69fd76899107605a8f371ea3
$(PKG)_SUBDIR   := qtwebkit-everywhere-src-$($(PKG)_VERSION)
$(PKG)_FILE     := qtwebkit-everywhere-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://download.qt.io/snapshots/ci/qtwebkit/5.212/latest/src/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libxml2 libxslt libwebp qtbase qtmultimedia qtquickcontrols \
                   qtsensors qtwebchannel sqlite

define $(PKG)_BUILD_SHARED
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DCMAKE_INSTALL_PREFIX=$(PREFIX)/$(TARGET)/qt5 \
        -DCMAKE_CXX_FLAGS='-fpermissive' \
        -DEGPF_DEPS='Qt5Core Qt5Gui Qt5Multimedia Qt5Widgets Qt5WebKit' \
        -DPORT=Qt \
        -DENABLE_GEOLOCATION=OFF \
        -DENABLE_MEDIA_SOURCE=ON \
        -DENABLE_VIDEO=ON \
        -DENABLE_WEB_AUDIO=ON \
        -DUSE_GSTREAMER=OFF \
        -DUSE_MEDIA_FOUNDATION=OFF \
        -DUSE_QT_MULTIMEDIA=ON
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # build test manually
    # add $(BUILD_TYPE_SUFFIX) for debug builds - see qtbase.mk
    $(TARGET)-g++ \
        -W -Wall -std=c++11 \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `$(TARGET)-pkg-config Qt5WebKitWidgets --cflags --libs`

    # batch file to run test programs
    (printf 'set PATH=..\\lib;..\\qt5\\bin;..\\qt5\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=..\\qt5\\plugins\r\n'; \
     printf 'test-$(PKG).exe\r\n'; \
     printf 'cmd\r\n';) \
     > '$(PREFIX)/$(TARGET)/bin/test-$(PKG).bat'
endef
