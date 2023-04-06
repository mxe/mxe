# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := qtkeychain
$(PKG)_WEBSITE  := https://github.com/frankosterfeld/qtkeychain
$(PKG)_DESCR    := QtKeychain
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.2
$(PKG)_CHECKSUM := 20beeb32de7c4eb0af9039b21e18370faf847ac8697ab3045906076afbc4caa5
$(PKG)_GH_CONF  := frankosterfeld/qtkeychain/tags,v
$(PKG)_DEPS     := cc qttools

define $(PKG)_BUILD_COMMON
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DQTKEYCHAIN_STATIC=$(CMAKE_STATIC_BOOL) \
        -DBUILD_TEST_APPLICATION="OFF" \
        -DBUILD_WITH_QT6=@build_with_qt6@
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install

    # Qt6 does not provide pkgconfig files for static builds
    test '@build_with_qt6@' = 'on' -a '$(BUILD_STATIC)' || \
    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic -std=c++17 \
        '$(SOURCE_DIR)/testclient.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' @qtcore_pkgconfig_module@ --cflags --libs` \
        '-I$(PREFIX)/$(TARGET)/include/@qt_version_prefix@keychain' -l@qt_version_prefix@keychain

    # create a batch file to run the test (as the test program requires arguments)
    # Note: the keychain uses APIs that are only available on Windows7 and newer.
    (printf 'REM Run the common actions against the test program.\r\n'; \
     printf 'REM First add a new user to the keychain, with the password badpass\r\n'; \
     printf 'test-@qt_version_prefix@keychain.exe store username badpass\r\n'; \
     printf 'REM The result of the next command should read badpass\r\n'; \
     printf 'test-@qt_version_prefix@keychain.exe restore username\r\n'; \
     printf 'REM Now we delete the user from the keychain\r\n'; \
     printf 'test-@qt_version_prefix@keychain.exe delete username\r\n'; \
     printf 'REM The result of the next command should fail as the user has been removed from the keychain\r\n'; \
     printf 'test-@qt_version_prefix@keychain.exe delete username\r\n';) \
> '$(PREFIX)/$(TARGET)/bin/test-@qt_version_prefix@keychain.bat'
endef

$(PKG)_BUILD = $(subst @build_with_qt6@,off, \
               $(subst @qt_version_prefix@,qt5, \
               $(subst @qtcore_pkgconfig_module@,Qt5Core, \
               $($(PKG)_BUILD_COMMON))))
