# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencl-headers
$(PKG)_WEBSITE  := https://www.khronos.org/registry/OpenCL/
$(PKG)_DESCR    := Khronos OpenCL-Headers
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := f039db6
# master branch has subdirectories for the latest version of each spec
$(PKG)_API      := 22
$(PKG)_CHECKSUM := 545efc0af7033ad01657c39812a074f33eb21a49bc84f23f07e5f0bc0a1e121e
$(PKG)_GH_CONF  := KhronosGroup/OpenCL-Headers/master
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/CL'
    $(INSTALL) -m644 '$(SOURCE_DIR)/opencl$($(PKG)_API)/CL/'*.h '$(PREFIX)/$(TARGET)/include/CL/'
endef
