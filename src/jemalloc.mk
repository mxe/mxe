# This file is part of MXE. See LICENSE.md for licensing information.
# Initial package scaffold generated with the "gsrc" tool:
# https://github.com/hkunz/git-fetcher

PKG             := jemalloc
$(PKG)_WEBSITE  := http://jemalloc.net/
$(PKG)_DESCR    := Custom ref :-5.3.0 (no upstream description)
$(PKG)_VERSION  := 5.3.0
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ef6f74fd45e95ee4ef7f9e19ebe5b075ca6b7fbe0140612b2a161abafb7ee179
$(PKG)_GH_CONF  := jemalloc/jemalloc/tags
$(PKG)_DEPS     := cc

define $(PKG)_BUILD

	# generate configure script first
	cd "$(SOURCE_DIR)" && ./autogen.sh

	# Configure package
	cd "$(BUILD_DIR)" && "$(SOURCE_DIR)/configure" \
		$(MXE_CONFIGURE_OPTS) \
		--host="$(TARGET)" \
		--prefix="$(PREFIX)/$(TARGET)"

	# build package and install
	$(MAKE) -C "$(BUILD_DIR)" -j $(JOBS)
	$(MAKE) -C "$(BUILD_DIR)" -j 1 install

	# compile a test program to verify the library is usable
	"$(TARGET)-g++" -Wall -Wextra "$(TEST_FILE)" \
		-o "$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe" \
		`"$(TARGET)-pkg-config" "$(PKG)" --cflags --libs`
endef
