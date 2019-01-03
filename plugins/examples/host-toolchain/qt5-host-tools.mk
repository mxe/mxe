# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := $(basename $(notdir $(lastword $(MAKEFILE_LIST))))
$(PKG)_FILE      = $(qtbase_FILE)
$(PKG)_PATCHES   = $(realpath $(sort $(wildcard $(addsuffix /qtbase-[0-9]*.patch, $(TOP_DIR)/src))))
$(PKG)_SUBDIR    = $(qtbase_SUBDIR)
$(PKG)_DEPS     := cc gcc-host make-host qtbase winpthreads-host

# main configure options: -platform -host-option -external-hostbindir
# further testing needed: -prefix -extprefix -hostprefix -sysroot -no-gcc-sysroot
#                         and keeping options synced with qtbase

define $(PKG)_BUILD
    $(SED) -i 's,BUILD_ON_MAC=yes,BUILD_ON_MAC=no,g' '$(1)/configure'
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        -prefix '$(PREFIX)/$(TARGET)/qt5' \
        $(if $(BUILD_STATIC),-static,-shared) \
        -release \
        -c++std c++11 \
        -platform win32-g++ \
        -host-option CROSS_COMPILE=${TARGET}- \
        -external-hostbindir '$(PREFIX)/$(TARGET)/qt5/bin' \
        -device-option PKG_CONFIG='$(TARGET)-pkg-config' \
        -device-option CROSS_COMPILE=$(TARGET)- \
        -force-pkg-config \
        -no-icu \
        -no-sql-{db2,ibase,mysql,oci,odbc,psql,sqlite,sqlite2,tds} \
        -no-use-gold-linker \
        -nomake examples \
        -nomake tests \
        -opensource \
        -confirm-license \
        -continue \
        -verbose

    # generate remaining build configuration (qmake is created by configure)
    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS) \
        sub-src-qmake_all

    # build other tools
    $(MAKE) -C '$(BUILD_DIR)/src' -j $(JOBS) \
        sub-{moc,qdbuscpp2xml,qdbusxml2cpp,qlalr,rcc,uic}-all

    # install tools and create `qt.conf` for runtime config
    cp '$(BUILD_DIR)/bin'/*.exe '$(PREFIX)/$(TARGET)/qt5/bin/'
    (printf '[Paths]\r\n'; \
     printf 'Prefix = ..\r\n'; \
    ) > '$(PREFIX)/$(TARGET)/qt5/bin/qt.conf'

    # test compilation on host
    # windows can't work with symlinks
    $(and $(BUILD_STATIC),
    rm -f '$(PREFIX)/$(TARGET)/lib/libpng.a' && \
        cp '$(PREFIX)/$(TARGET)/lib/libpng16.a' '$(PREFIX)/$(TARGET)/lib/libpng.a';
    rm -f '$(PREFIX)/$(TARGET)/lib/libharfbuzz_too.a' && \
        cp '$(PREFIX)/$(TARGET)/lib/libharfbuzz.a' '$(PREFIX)/$(TARGET)/lib/libharfbuzz_too.a';
    )

    # copy required test files and create batch file
    mkdir -p '$(PREFIX)/$(TARGET)/qt5/test-$(PKG)'
    cp '$(PWD)/src/qt-test.'* '$(PREFIX)/$(TARGET)/qt5/test-$(PKG)/'
    cp '$(PWD)/src/qt.mk'     '$(PREFIX)/$(TARGET)/qt5/test-$(PKG)/'
    (printf 'set PWD=%%~dp0\r\n'; \
     printf 'set PATH=%%PWD%%..\\bin;%%PWD%%..\\..\\bin;%%PWD%%..\\lib;%%PWD%%..\\..\\lib;%%PATH%%\r\n'; \
     printf 'set QT_QPA_PLATFORM_PLUGIN_PATH=%%PWD%%..\\plugins\r\n'; \
     printf 'mkdir build\r\n'; \
     printf 'cd build\r\n'; \
     printf 'qmake ..\r\n'; \
     printf 'make -j $(JOBS)\r\n'; \
     printf '%%PWD%%\\build\\release\\test-qt5.exe\r\n'; \
     printf 'cmd\r\n'; \
    ) > '$(PREFIX)/$(TARGET)/qt5/test-$(PKG)/test-$(PKG).bat'
endef
