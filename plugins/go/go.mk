# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := go
$(PKG)_WEBSITE  := https://golang.org/
$(PKG)_OWNER    := https://github.com/starius
$(PKG)_SUBDIR   := go
$(PKG)_TYPE     := meta

GO := $(shell which go)

define $(PKG)_BUILD
    # Make sure Go binary was found.
    $(GO) version

    # Create prefixed go wrapper script.
    mkdir -p '$(PREFIX)/bin/$(TARGET)'
    (echo '#!/usr/bin/env bash'; \
     echo 'echo "== Using MXE Go wrapper: $(PREFIX)/bin/$(TARGET)-go"'; \
     echo 'set -xue'; \
     echo 'CGO_ENABLED=1 \'; \
     echo 'GOOS=windows \'; \
     echo 'GOARCH=$(if $(findstring x86_64,$(TARGET)),amd64,386) \'; \
     echo 'DYLD_INSERT_LIBRARIES= \'; \
     echo 'CC=$(PREFIX)/bin/$(TARGET)-gcc \'; \
     echo 'CXX=$(PREFIX)/bin/$(TARGET)-g++ \'; \
     echo 'PKG_CONFIG=$(PREFIX)/bin/$(TARGET)-pkg-config \'; \
     echo 'exec $(GO) \'; \
     echo '"$$@"'; \
    ) \
             > '$(PREFIX)/bin/$(TARGET)-go'
    chmod 0755 '$(PREFIX)/bin/$(TARGET)-go'

    cd $(PWD)/plugins/go/mxe-test && '$(TARGET)-go' build \
        -o '$(PREFIX)/$(TARGET)/bin/test-go.exe' .
endef

# -buildmode=shared not supported on windows
# See https://golang.org/s/execmodes
$(PKG)_BUILD_SHARED =
