# This file is part of MXE.
# See index.html for further information.

PKG            := mxe-conf
$(PKG)_VERSION := 1
$(PKG)_UPDATE  := echo 1
$(PKG)_TARGETS := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD
    # create basic non-empty directory hierarchy
    for d in bin include lib share; do \
        mkdir -p "$(PREFIX)/$(TARGET)/$$d" && \
        touch    "$(PREFIX)/$(TARGET)/$$d/.gitkeep" ; \
    done

    # install target-specific autotools config file
    # setting ac_cv_build bypasses the config.guess check in every package
    echo "ac_cv_build=$(BUILD)" > '$(PREFIX)/$(TARGET)/share/config.site'

    # create the CMake toolchain file
    # individual packages (e.g. hdf5) should add their
    # own files under CMAKE_TOOLCHAIN_DIR
    mkdir -p '$(CMAKE_TOOLCHAIN_DIR)'
    touch '$(CMAKE_TOOLCHAIN_DIR)/.gitkeep'
    (echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
     echo 'set(MSYS 1)'; \
     echo 'set(BUILD_SHARED_LIBS $(if $(BUILD_SHARED),ON,OFF))'; \
     echo 'set(LIBTYPE $(if $(BUILD_SHARED),SHARED,STATIC))'; \
     echo 'set(CMAKE_PREFIX_PATH $(PREFIX)/$(TARGET))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $(PREFIX)/$(TARGET))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $(PREFIX)/bin/$(TARGET)-gcc)'; \
     echo 'set(CMAKE_CXX_COMPILER $(PREFIX)/bin/$(TARGET)-g++)'; \
     echo 'set(CMAKE_Fortran_COMPILER $(PREFIX)/bin/$(TARGET)-gfortran)'; \
     echo 'set(CMAKE_RC_COMPILER $(PREFIX)/bin/$(TARGET)-windres)'; \
     echo 'set(CMAKE_MODULE_PATH "$(PREFIX)/share/cmake/modules" $${CMAKE_MODULE_PATH}) # For mxe FindPackage scripts'; \
     echo 'set(CMAKE_INSTALL_PREFIX $(PREFIX)/$(TARGET) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")'; \
     echo 'set(CMAKE_CROSS_COMPILING ON) # Workaround for http://www.cmake.org/Bug/view.php?id=14075'; \
     echo 'set(CMAKE_RC_COMPILE_OBJECT "<CMAKE_RC_COMPILER> -O coff <FLAGS> <DEFINES> -o <OBJECT> <SOURCE>") # Workaround for buggy windres rules'; \
     echo ''; \
     echo 'file(GLOB mxe_cmake_files'; \
     echo '    "$(CMAKE_TOOLCHAIN_DIR)/*.cmake"'; \
     echo ')'; \
     echo 'foreach(mxe_cmake_file $${mxe_cmake_files})'; \
     echo '    include($${mxe_cmake_file})'; \
     echo 'endforeach()'; \
     ) > '$(CMAKE_TOOLCHAIN_FILE)'

    #create prefixed cmake wrapper script
    (echo '#!/usr/bin/env bash'; \
     echo 'echo "== Using MXE wrapper: $(PREFIX)/bin/$(TARGET)-cmake"'; \
     echo 'unset NO_MXE_TOOLCHAIN'; \
     echo 'if echo -- "$$@" | grep -Ewq "(--build|-E|--system-information)" ; then'; \
     echo '    NO_MXE_TOOLCHAIN=1'; \
     echo 'fi'; \
     echo 'if [[ "$$NO_MXE_TOOLCHAIN" == "1" ]]; then'; \
     echo '    echo "== Skip using MXE toolchain: $(CMAKE_TOOLCHAIN_FILE)"'; \
     echo '    # see https://github.com/mxe/mxe/issues/932'; \
     echo '    exec "$(PREFIX)/$(BUILD)/bin/cmake" "$$@"'; \
     echo 'else'; \
     echo '    echo "== Using MXE toolchain: $(CMAKE_TOOLCHAIN_FILE)"'; \
     echo '    echo "== Using MXE runresult: $(CMAKE_RUNRESULT_FILE)"'; \
     echo '    exec "$(PREFIX)/$(BUILD)/bin/cmake" \
                         -DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" \
                         -C"$(CMAKE_RUNRESULT_FILE)" "$$@"'; \
     echo 'fi'; \
    ) \
             > '$(PREFIX)/bin/$(TARGET)-cmake'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-cmake'

    # create pkg-config files for OpenGL/GLU
    mkdir -p '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: gl'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lopengl32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/gl.pc'
    (echo 'Name: glu'; \
     echo 'Version: 0'; \
     echo 'Description: OpenGL'; \
     echo 'Libs: -lglu32';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/glu.pc'

endef

define $(PKG)_BUILD_$(BUILD)
    # install config.guess for general use
    mkdir -p '$(PREFIX)/bin'
    $(INSTALL) -m755 '$(EXT_DIR)/config.guess' '$(PREFIX)/bin/'

    # install cmake modules
    mkdir -p '$(PREFIX)/share/cmake/modules'
    $(INSTALL) -m644 '$(PWD)/src/cmake/modules/'* '$(PREFIX)/share/cmake/modules'

    # fail early if autotools can't autoreconf
    # 1. detect mismatches in installation locations
    # 2. ???
    (echo 'AC_INIT([mxe.cc], [1])'; \
     $(foreach PROG, autoconf automake libtool, \
         echo 'AC_PATH_PROG([$(call uc,$(PROG))], [$(PROG)])';) \
     echo 'PKG_PROG_PKG_CONFIG(0.16)'; \
     echo 'AC_OUTPUT') \
     > '$(1)/configure.ac'
    cd '$(1)' && autoreconf -fiv
    cd '$(1)' && ./configure

    #create readonly directory to force wine to fail
    mkdir -p "$$WINEPREFIX"
    [ -f "$$WINEPREFIX/.gitkeep" ] \
        || chmod 0755 "$$WINEPREFIX" \
        && touch "$$WINEPREFIX/.gitkeep"
    chmod 0555 "$$WINEPREFIX"

    #create script "wine" in a directory which is in PATH
    mkdir -p '$(PREFIX)/$(BUILD)/bin/'
    (echo '#!/usr/bin/env bash'; \
     echo 'exit 1'; \
    ) \
             > '$(PREFIX)/$(BUILD)/bin/wine'
    chmod 0755 '$(PREFIX)/$(BUILD)/bin/wine'
endef
