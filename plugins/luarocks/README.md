LuaRocks plugin
===============

Short description of LuaRocks
-----------------------------

Hundreds of [Lua][lua] packages are distributed via [LuaRocks][luarocks].
LuaRocks is the package manager for Lua. It allows you to create and
install Luamodules as self-contained packages called rocks. You can
download and install LuaRocks on Unix and Windows.

Lua rocks are similar to Ruby gems, Python eggs or JavaScript NPM. Command
`luarocks install <rock>` downloads a rock from [luarocks.org][luarocks]
(or other luarocks server), compiles C files (modules) to shared libraries
and installs (copies) shared libraries and Lua files to the directory
where luarocks is installed. Installed rocks can be loaded from Lua with
function `require`.

Example:
```
$ luarocks install luasocket
$ lua -e 'http = require "socket.http"; print(http.request("http://example.org/"))'
<!DOCTYPE html>
....
```

LuaRocks can used with `make`, `cmake`, custom or builtin
 [back-ends][backends].

LuaRocks in MXE
---------------

LuaRocks and some popular rocks were ported to MXE as a plugin.
LuaRocks can now be used in the same way as CMake or Make.

Package `lua` installs native executable usr/bin/lua and
cross-compiled lua executable usr/<target>/bin/lua.exe. Native
executable is needed since LuaRocks is written in Lua. Cross-compiled
one is needed to run Lua scripts loading cross-compiled lua modules.

Package `luarocks` was added. Luarocks was patched to support new
platform `mxe`, inherited from platform `unix`. It uses mix of system
tools (e.g., `openssl`, `ln`, `mkdir`), MXE build chain
(`i686-w64-mingw32.shared-gcc`, `i686-w64-mingw32.shared-cmake`) and some
Windows variables (e.g., "dll" extension for shared libraries). The
package is shared-only because Lua loads modules in runtime. It
creates prefixed luarocks tool in `usr/bin`. It also creates prefixed
wine+lua wrapper aware of locations of dll and lua files installed.
This script can be used to test modules in Linux as if running them in
Windows.

There was a difficult choice if `mxe` platform of luarocks is inherited
from `windows` or `unix` platform. I tried both and it is less patching
for `unix`. For `windows` even build tools differ, while for `unix` a
typical rock builds without patching or with minor patching
(as other MXE packages).

LuaRocks can be used to install rocks. With ideal rock it works as follows:

```
$ i686-w64-mingw32.shared-luarocks install <rock>
```

This command downloads rockspeck, downloads sources, verifies checksum
(useless thing, because checksum is compared to the value from rockspec
file, which itself is neither verified nor signed), builds and installs.

LuaRocks is not used to download source tarballs (as said
above, it doesn't verify checksums properly) using MXE's downloading
and verifying facilities instead. Luarocks is used as builder,
installer and Lua library (it installs Lua files to
`usr/i686-w64-mingw32.shared/share/lua/5.3/luarocks/`).

Build all rocks:
```
$ make all-luarocks MXE_PLUGIN_DIRS=plugins/luarocks MXE_TARGETS='i686-w64-mingw32.shared x86_64-w64-mingw32.shared'
```

Run tests (requires wine):
```
$ ./usr/bin/i686-w64-mingw32.shared-lua plugins/luarocks/test.lua
```

See also:

  * [LuaRocks site][luarocks]
  * [LuaRocks wiki][wiki]
  * [the thread in MXE mailing list about LuaRocks in MXE][thread]

[lua]:https://lua.org/
[luarocks]:https://luarocks.org/
[backends]:https://github.com/keplerproject/luarocks/wiki/Rockspec-format#Build_backends
[wiki]:https://github.com/keplerproject/luarocks/wiki/
[thread]:https://lists.nongnu.org/archive/html/mingw-cross-env-list/2015-10/msg00008.html
