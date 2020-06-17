# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm
$(PKG)_WEBSITE  := https://llvm.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 10.0.0
$(PKG)_CHECKSUM := df83a44b3a9a71029049ec101fb0077ecbbdf5fe41e395215025779099a98fdf
$(PKG)_GH_CONF  := llvm/llvm-project/releases/latest, llvmorg-
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION).src
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.xz
$(PKG)_URL      := https://github.com/llvm/llvm-project/releases/download/llvmorg-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc $(BUILD)~$(PKG)
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
$(PKG)_DEPS_$(BUILD) := cmake

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && $(TARGET)-cmake '$(SOURCE_DIR)' \
        -DLLVM_TABLEGEN='$(PREFIX)/$(BUILD)/bin/llvm-tblgen' \
        -DLLVM_TARGETS_TO_BUILD=X86 \
        -DLLVM_TARGET_ARCH=X86 \
        -DLLVM_BUILD_DOCS=OFF \
        -DLLVM_BUILD_EXAMPLES=OFF \
        -DLLVM_BUILD_RUNTIME=OFF \
        -DLLVM_BUILD_RUNTIMES=OFF \
        -DLLVM_BUILD_TESTS=OFF \
        -DLLVM_BUILD_TOOLS=OFF \
        -DLLVM_BUILD_UTILS=OFF \
        -DLLVM_ENABLE_BINDINGS=OFF \
        -DLLVM_ENABLE_DOXYGEN=OFF \
        -DLLVM_ENABLE_OCAMLDOC=OFF \
        -DLLVM_ENABLE_SPHINX=OFF \
        -DLLVM_INCLUDE_DOCS=OFF \
        -DLLVM_INCLUDE_EXAMPLES=OFF \
        -DLLVM_INCLUDE_GO_TESTS=OFF \
        -DLLVM_INCLUDE_RUNTIMES=OFF \
        -DLLVM_INCLUDE_TESTS=OFF \
        -DLLVM_INCLUDE_TOOLS=OFF \
        -DLLVM_INCLUDE_UTILS=OFF
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' -k -l '$(JOBS)' VERBOSE=1 || $(MAKE) -C '$(BUILD_DIR)' -j 1 -l 1 VERBOSE=1
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && cmake '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' llvm-tblgen VERBOSE=1
    cp '$(BUILD_DIR)'/bin/* '$(PREFIX)/$(TARGET)/bin/'
endef
