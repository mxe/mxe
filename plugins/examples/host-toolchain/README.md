Cross Compiling a Host Toolchain
--------------------------------

This plugin demonstrates a minimal working toolchain built with MXE to
execute on a Windows host. To build:

```
make gcc-host MXE_PLUGIN_DIRS=plugins/examples/host-toolchain/
```

This will run the usual steps to build a cross-compiler, then build a
second pass to cross-compile the basic toolchain (`binutils` and `gcc`).

Once complete, copy `usr/{target}` to an appropriate Windows machine
and execute the `usr\{target}\bin\test-gcc-host.bat` batch file. This
builds and runs the `libgomp` test as a sanity check.

Why?
----

Simply for curiosity, it's hard to see a practical use for this. Certainly,
attempting to use it as a way to bootstrap MXE on Windows would strain
one's sanity and cross-compiling is the recommended way (even if that means
running a Linux VM on Windows).
