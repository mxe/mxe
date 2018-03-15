# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtkeychain
$(PKG)_WEBSITE  := https://github.com/frankosterfeld/qtkeychain
$(PKG)_DESCR    := QtKeychain
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.0
$(PKG)_CHECKSUM := b492f603197538bc04b2714105b1ab2b327a9a98d400d53d9a7cb70edd2db12f
$(PKG)_GH_CONF  := frankosterfeld/qtkeychain/tags,v
$(PKG)_DEPS     := cc qttools

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DQTKEYCHAIN_STATIC=$(CMAKE_STATIC_BOOL)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++11 \
        '$(SOURCE_DIR)/testclient.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-qt5keychain.exe' \
        `'$(TARGET)-pkg-config' Qt5Core --cflags --libs` \
        '-I$(PREFIX)/$(TARGET)/include/qt5keychain' -lqt5keychain

    # create a batch file to run the test (as the test program requires arguments)
    # Note: the keychain uses APIs that are only available on Windows7 and newer.
    (printf 'REM Run the common actions against the test program.\r\n'; \
     printf 'REM First add a new user to the keychain, with the password badpass\r\n'; \
     printf 'test-qt5keychain.exe store username badpass\r\n'; \
     printf 'REM The result of the next command should read badpass\r\n'; \
     printf 'test-qt5keychain.exe restore username\r\n'; \
     printf 'REM Now we delete the user from the keychain\r\n'; \
     printf 'test-qt5keychain.exe delete username\r\n'; \
     printf 'REM The result of the next command should fail as the user has been removed from the keychain\r\n'; \
     printf 'test-qt5keychain.exe delete username\r\n';) \
> '$(PREFIX)/$(TARGET)/bin/test-qt5keychain.bat'
endef
