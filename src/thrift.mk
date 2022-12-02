PKG             := thrift
$(PKG)_WEBSITE  := https://thrift.apache.org/
$(PKG)_DESCR    := Apache Thrift (runtime libraries only)
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.17.0
$(PKG)_CHECKSUM := b272c1788bb165d99521a2599b31b97fa69e5931d099015d91ae107a0b0cc58f
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

