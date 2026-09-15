# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := llvm
$(PKG)_WEBSITE  := https://llvm.org/
$(PKG)_DESCR    := Compiler infrastructure and toolchain libraries used for building compilers and JIT-based systems.
$(PKG)_VERSION  := 22.1.3
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7e144bd6da8177757434cc0dfd1476122f143413df379c6d6cf03843512b5a9e
$(PKG)_GH_CONF  := llvm/llvm-project/tags,llvmorg-
$(PKG)_DEPS     := cc curl icu4c isl libxml2 pkgconf protobuf zlib zstd

define $(PKG)_BUILD

	# configure package with cmake
	cd "$(BUILD_DIR)" && "$(TARGET)-cmake" "$(SOURCE_DIR)/llvm" \
		-DCMAKE_INSTALL_PREFIX="$(PREFIX)/$(TARGET)" \
		-DCMAKE_PREFIX_PATH="$(PREFIX)/$(TARGET)" \
		-DBUILD_SHARED_LIBS=$(CMAKE_SHARED_BOOL) \
		-DLLVM_FORCE_VC_REPOSITORY=https://github.com/llvm/llvm-project.git \
		-DLLVM_TARGETS_TO_BUILD=X86 \
		-DLLVM_ENABLE_PROJECTS=clang \
		-DLLVM_BUILD_TOOLS=ON \
		-DLLVM_BUILD_TESTS=OFF \
		-DLLVM_INCLUDE_TOOLS=ON \
		-DLLVM_INCLUDE_TESTS=OFF \
		-DLLVM_INCLUDE_EXAMPLES=OFF \
		-DLLVM_INSTALL_TOOLCHAIN_ONLY=OFF \
		-DCMAKE_BUILD_TYPE=Release

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		`"$(PREFIX)/$(TARGET)/bin/llvm-config.exe" --cxxflags --libs core support irreader --system-libs` \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe"
endef
