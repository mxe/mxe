# Go plugin for MXE

See also article [cross-compile go code, including cgo][1]
by Dimitri John Ledkov.

[1]: https://blog.surgut.co.uk/2014/06/cross-compile-go-code-including-cgo.html

Package `go-native` installs native Go 1.4. This version of Go
doesn't depend on Go installation.

Package `go` uses native Go 1.4 as a bootstrap and installs Go 1.6
as a cross-compiler to windows/386 or windows/amd64. Versions of
Go starting with 1.5 need Go installation to build.

To build Go packages for windows/386 or windows/amd64, you have to set
the [GOPATH](https://golang.org/doc/code.html#GOPATH) environment variable
and call `usr/bin/$(TARGET)-go` wrapper script.

## Example

Building [gohs](https://github.com/flier/gohs), GoLang Binding of
[HyperScan](https://01.org/hyperscan).

```
$ make hyperscan go MXE_PLUGIN_DIRS=plugins/go
$ mkdir gopath
$ GOPATH=`pwd`/gopath ./usr/bin/i686-w64-mingw32.static-go get \
    github.com/flier/gohs/examples/simplegrep
$ ./gopath/bin/windows_386/simplegrep.exe root /etc/passwd
Scanning 42 bytes with Hyperscan
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
```
