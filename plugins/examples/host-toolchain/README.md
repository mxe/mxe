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

  - [MSYS2][msys2]
  - [Git for Windows][git-win] - uses MSYS2
  - [ConEmu][conemu] - usable terminal
  - [cmder][cmder] - bundles ConEmu and Git

#### Make

```
make make-host MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will cross-compile GNU Make from source (without guile support).

#### pkgconf/pkg-config

```
make pkgconf-host MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will cross-compile `pkgconf` and create the `pkg-config` wrapper. The
wrapper requires `/bin/sh` so one of the [MSYS2][msys2] options should be used.
Run the `usr/{target}/bin/test-pkgconf-host` script to build `libffi` test
with non-standard include paths.

#### Qt5 tools (`qmake.exe`, `rcc.exe`, etc.)

```
make qt5-host-tools MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will build `qtbase` and cross-compile the toolchain/qt tools/make

On a windows machine, execute
`usr\{target}\qt5\test-qt5-host-tools\test-qt5-host-tools.bat` to build and
confirm the normal `qt` test with the cross-compiled `qtbase` libraries.

Why?
----

Simply for curiosity, it's hard to see a practical use for this. Certainly,
attempting to use it as a way to bootstrap MXE on Windows would strain
one's sanity and cross-compiling is the recommended way (even if that means
running a Linux VM on Windows).



[cmake-generators]:https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html
[cmder]:https://cmder.net/
[conemu]:https://conemu.github.io/
[git-win]:https://git-for-windows.github.io/
[msys2]:https://msys2.github.io/
