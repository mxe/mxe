PKG             := thrift
$(PKG)_WEBSITE  := https://thrift.apache.org/
$(PKG)_DESCR    := Apache Thrift (runtime libraries only)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.18.1
$(PKG)_CHECKSUM := 04c6f10e5d788ca78e13ee2ef0d2152c7b070c0af55483d6b942e29cff296726
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dlcdn.apache.org/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://dlcdn.apache.org/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc openssl boost libevent

define $(PKG)_BUILD
    find '$(SOURCE_DIR)' \
        -type f \( -iname '*.h' -o -iname '*.cpp' \) \
        -exec sed -i -e 's/Windows[.]h/windows.h/g' \
                     -e 's/Shlwapi[.]h/shlwapi.h/g' \
                     -e 's/AccCtrl[.]h/accctrl.h/g' \
                     -e 's/Aclapi[.]h/aclapi.h/g' \
                     -e 's/WS2tcpip[.]h/ws2tcpip.h/g' '{}' \+
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' \
        -DCMAKE_CXX_STANDARD=17 \
        -DBUILD_CPP=ON \
        -DBUILD_COMPILER=OFF \
        -DBUILD_PYTHON=OFF \
        -DBUILD_NODEJS=OFF \
        -DBUILD_TESTING=OFF \
        -DBUILD_C_GLIB=OFF \
        '$(SOURCE_DIR)'

    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' install
endef

