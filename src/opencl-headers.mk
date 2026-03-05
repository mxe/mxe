# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencl-headers
$(PKG)_DESCR    := Khronos OpenCL C headers for OpenCL API development
$(PKG)_WEBSITE  := https://github.com/KhronosGroup/OpenCL-Headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2025.07.22
$(PKG)_CHECKSUM := 98f0a3ea26b4aec051e533cb1750db2998ab8e82eda97269ed6efe66ec94a240
$(PKG)_GH_CONF  := KhronosGroup/OpenCL-Headers/tags,v
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(BUILD_DIR)'
    # Normally, the CMakeLists.txt builds an INTERFACE library
    # No compilation needed; just copy the headers
    mkdir -p '$(PREFIX)/$(TARGET)/include'
    cp -r '$(SOURCE_DIR)/CL' '$(PREFIX)/$(TARGET)/include/'
endef
