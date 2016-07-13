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
builds and runs the `libgomp` test as a sanity check.

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

Why?
----

Simply for curiosity, it's hard to see a practical use for this. Certainly,
attempting to use it as a way to bootstrap MXE on Windows would strain
one's sanity and cross-compiling is the recommended way (even if that means
running a Linux VM on Windows).
