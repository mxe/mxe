# MXE (M cross environment)

[![License][license-badge]][license-page]

[license-page]: LICENSE.md
[license-badge]: https://img.shields.io/badge/License-MIT-brightgreen.svg

MXE (M cross environment) is a GNU Makefile that compiles a cross
compiler and cross compiles many free libraries such as SDL and
Qt. Thus, it provides a nice cross compiling environment for
various target platforms, which:

  * is designed to run on any Unix system
  * is easy to adapt and to extend
  * builds many free libraries in addition to the cross compiler
  * can also build just a subset of the packages, and automatically builds their dependencies
  * downloads all needed packages and verifies them by their checksums
  * is able to update the version numbers of all packages automatically
  * directly uses source packages, thus ensuring the whole build mechanism is transparent
  * allows inter-package and intra-package parallel builds whenever possible
  * bundles [ccache](https://ccache.samba.org) to speed up repeated builds
  * integrates well with autotools, cmake, qmake, and hand-written makefiles.
  * has been in continuous development since 2007 and is used by several projects

## Supported Toolchains

  * Runtime: MinGW-w64
  * Host Triplets:
    - `i686-w64-mingw32`
    - `x86_64-w64-mingw32`
  * Packages:
    - static
    - shared
  * GCC Threading Libraries (`winpthreads` is always available):
    - [posix](https://github.com/mxe/mxe/pull/958) [(default)](https://github.com/mxe/mxe/issues/2258)
    - win32 (supported by limited amount packages)
  * GCC Exception Handling:
    - Default
      - i686: sjlj
      - x86_64: seh
    - [Alternatives (experimental)](https://github.com/mxe/mxe/pull/1664)
      - i686: dw2
      - x86_64: sjlj

Please see [mxe.cc](https://mxe.cc/) for further information and package support matrix.

## Shared Library Notes
There are several approaches to recursively finding DLL dependencies (alphabetical list):
  * [go script](https://github.com/desertbit/gml/blob/master/cmd/gml-copy-dlls/main.go)
  * [pe-util](https://github.com/gsauthof/pe-util) packaged with [mxe](https://github.com/mxe/mxe/blob/master/src/pe-util.mk)
  * [python script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.py)
  * [shell script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.md)
