Cross Compiling a Host Toolchain
--------------------------------

This plugin demonstrates a minimal working toolchain built with MXE to
execute on a Windows host.

#### GCC

```
make gcc-host MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will run the usual steps to build a cross-compiler, then build a
second pass to cross-compile the basic toolchain (`binutils` and `gcc`).

Once complete, copy `usr/{target}` to an appropriate Windows machine
and execute the `usr\{target}\bin\test-gcc-host.bat` batch file. This
builds and runs the `libgomp` test as a sanity check. The cross and host
built programs should be identical (after stripping), confirmed with the
final step:

```
>fc /b test-gcc-host.exe test-pthreads-libgomp.exe
Comparing files test-gcc-host.exe and TEST-PTHREADS-LIBGOMP.EXE
FC: no differences encountered
```

#### Qt5 tools (`qmake.exe`, `rcc.exe`, etc.)

```
make qt5-host-tools MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will build `qtbase`, cross-compile the toolchain and qt tools, and
download `make` binaries from the source recommended by the GNU Make project.

On a windows machine, execute
`usr\{target}\qt5\test-qt5-host-tools\test-qt5-host-tools.bat` to build and
confirm the normal `qt` test with the cross-compiled `qtbase` libraries.

**N.B.** shared `gcc` doesn't work with the test program. To build a shared
test, use the additional option `gcc-host_CONFIGURE_OPTS=--disable-shared`.

#### CMake

```
make cmake-host MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

CMake defaults to Visual Studio generators and additional configuration is
required for [MinGW or MSYS Makefiles][cmake-generators]. MinGW uses `cmd.exe`
and requires `mingw32-make`, MSYS uses `make` and requires `/bin/sh`. The
latter is recommended for further investigation since it's closest to the
normal environment MXE expects. See the following projects for shells and
terminal emulators:

  - [MSYS2](https://msys2.github.io/)
  - [Git for Windows](https://git-for-windows.github.io/) - uses MSYS2
  - [ConEmu](https://conemu.github.io/) - usable terminal
  - [cmder](http://cmder.net/) - bundles ConEmu and Git

Why?
----

Simply for curiosity, it's hard to see a practical use for this. Certainly,
attempting to use it as a way to bootstrap MXE on Windows would strain
one's sanity and cross-compiling is the recommended way (even if that means
running a Linux VM on Windows).



[cmake-generators]:https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html
