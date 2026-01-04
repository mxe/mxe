# Go Plugin for MXE

Refer to the article [Cross-Compile Go Code, Including cgo][1] by
Dimitri John Ledkov for additional details.

[1]: https://blog.surgut.co.uk/2014/06/cross-compile-go-code-including-cgo.html

### Requirements

- A Go installation on the host system (the `go` tool must be available).

### Overview

This plugin generates a Bash script wrapper that runs the system Go
installation while setting up the necessary environment variables to
utilize MXE files (libraries, C compiler for cgo, pkg-config, etc.). It
enables building Go packages with cgo dependencies that rely on libraries
installed using MXE. The plugin supports cross-compilation for `windows/386`
and `windows/amd64` targets (in Go's target notation).

### Installation

```bash
# Verify that Go is installed on your system:
$ go version

# Install the plugin:
$ make go MXE_PLUGIN_DIRS=plugins/go
```

Once installed, you can use the `usr/bin/$(TARGET)-go` wrapper script,
which behaves like the standard `go` command but is configured to work
seamlessly with MXE.

### Example Usage

Below is an example of building [gohs](https://github.com/flier/gohs),
the GoLang binding for [HyperScan](https://github.com/intel/hyperscan):

```bash
$ make hyperscan go MXE_PLUGIN_DIRS=plugins/go
$ CGO_CFLAGS_ALLOW="-posix" ./usr/bin/i686-w64-mingw32.static-go install \
    github.com/flier/gohs/examples/simplegrep@latest
$ wine ~/go/bin/windows_386/simplegrep.exe root /etc/passwd
Scanning 42 bytes with Hyperscan
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
```

(Note: This example will work once
[flier/gohs#68](https://github.com/flier/gohs/pull/68) is merged.)
