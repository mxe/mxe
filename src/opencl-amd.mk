# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencl-amd
$(PKG)_WEBSITE  := https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK
$(PKG)_DESCR    := AMD OpenCL SDK Light
$(PKG)_IGNORE   := %
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := d1775637fc4b2531a4fd593bea1d8a6c70604bf410e8c9faa0b5d841b9ad9ff4
$(PKG)_GH_CONF  := GPUOpen-LibrariesAndSDKs/OCL-SDK
$(PKG)_SUBDIR   := app
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).inno.exe
$(PKG)_URL      := https://github.com/GPUOpen-LibrariesAndSDKs/OCL-SDK/releases/download/1.0/OCL_SDK_Light_AMD.exe
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    rm -rfv '$(PREFIX)/$(TARGET)/include/CL'
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/CL'
    $(INSTALL) -m644 '$(SOURCE_DIR)/include/CL/'*.h '$(PREFIX)/$(TARGET)/include/CL/'

    rm -fv '$(PREFIX)/$(TARGET)/lib/'*OpenCL*
    $(INSTALL) -m644 '$(SOURCE_DIR)/lib/x86$(if $(findstring x86_64,$(TARGET)),_64)/opencl.lib' \
                     '$(PREFIX)/$(TARGET)/lib/OpenCL.lib'
endef

# requires innoextract, see website for installation:
# https://constexpr.org/innoextract/
UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.Z,   $(1)),tar xzf '$(1)', \
    $(if $(filter %.tbz2,    $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.txz,     $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,  $(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.7z,      $(1)),7za x '$(1)', \
    $(if $(filter %.zip,     $(1)),unzip -q '$(1)', \
    $(if $(filter %.deb,     $(1)),ar x '$(1)' && tar xf data.tar*, \
    $(if $(filter %.inno.exe,$(1)),innoextract '$(1)', \
    $(error Unknown archive format: $(1))))))))))))))
