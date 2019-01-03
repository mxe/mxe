### MXE Plugins

#### Overview

MXE aims to provide a stable toolchain and feature-rich set of libraries to
be as broadly applicable as possible. Many use cases fall outside this main
objective and plugins are a way to bridge the gap without official framework
support.

The most common cases include:

##### Additional packages

  - building handy tools to run on host
  - cross-compiled interpreters and packages
  - examples of packaging complete builds for projects using MXE

The `apps`, `luarocks`, and `native` directories are generally supported by
the project, each plugin package should have an identified `$(PKG)_OWNER` as
a primary contact familiar with the specifics of the plugin.

##### Customisation

  - alternate compiler versions
  - minimal features/dependencies
  - building a host toolchain

The `examples` and `gcc*` directories contain some starting points for
experiments or long-lived customisations. Attempts to do such things with
`git` branches can lead to an outdated core MXE and using plugins allows a
nice separation while still keeping all local changes under source control.

These are experimental and will be deprecated over time as framework support
is added to handle the various forms of customisation.

##### Internal MXE uses

The `native` plugin contains sub-directories with symlinks to a subset of
packages in the parent directory. These "sub-plugins" are automatically
activated on certain systems where the standard package-manager versions are
known to cause issues. These are supported but subject to change or removal
over time and should not be used directly.

#### Usage

The current implementation is very lightweight and a `plugin` is simply a
directory containing *.mk files. When a plugin is activated with:

```
make MXE_PLUGIN_DIRS=/path/to/foo
```

MXE will:

  - include all core packages
  - include `/path/to/foo/*.mk`
  - create a target for each `*.mk` file
  - create an `all-foo` target

Multiple plugins can be activated on the command line with an escaped
space-separated list:

```
make MXE_PLUGIN_DIRS='/path/to/foo /path/to/foo2'
```

To ensure plugins are activated across multiple invocations of `make`, the
`MXE_PLUGIN_DIRS` variable must always be specified either on the command line
or by adding an entry in `settings.mk`

*N.B.* Setting `MXE_PLUGIN_DIRS` via the environment is not guaranteed to
work in future versions.

For example, if you want to build keepassx from the `apps` plugin with
a minimal qt run:

```
make keepassx MXE_PLUGIN_DIRS='plugins/examples/custom-qt-min plugins/apps'
```

To build all packages in `luarocks`:

```
$ make all-luarocks MXE_PLUGIN_DIRS=plugins/luarocks
```

To **always** use your desired plugin:

```
echo 'override MXE_PLUGIN_DIRS += /path/to/foo' >> settings.mk
```

Note that multiple entries in `settings.mk` should not be escaped:

```
echo 'override MXE_PLUGIN_DIRS += /path/to/foo /path/to/foo2' >> settings.mk
```

To review which plugins are activated, use the `gmsl-print-*` target:

```
make gmsl-print-MXE_PLUGIN_DIRS MXE_PLUGIN_DIRS='/foo /bar'
```

#### Creating plugins

The two main use cases lead to different styles of plugin. The first case of
additional packages follows normal MXE guidelines and reviewing the contents of
`src/*.mk`, or the `apps` and `luarocks` plugins should help getting started.
This type of package will also work with normal MXE features such as updates
and patches.

The customisation style (override/overlay) can be trickier since any arbitrary
`make` statements can be used. Most normal variables should be overridden with
[simply expanded variables](https://www.gnu.org/software/make/manual/html_node/Flavors.html#Flavors)
i.e. using `:=` instead of `=`. For example, to change a package version:

```make
PKG             := foo
$(PKG)_VERSION  := 1.2.3
$(PKG)_CHECKSUM := 09c4c85cab...
```

In this case, the behaviour of `make update-package-foo` may not be able to
determine the correct file to update with the new version and checksum and
`make` may not detect that the target should be rebuilt (depending on how
files are named). This is an on-going work that will be addressed.

To change the set of patches applied:

```make
foo_PATCHES := /path/to/first.patch /path/to/second.patch
```

To apply no patches:

```make
foo_PATCHES :=
```

To alter dependencies and components:

```make
qt_DEPS := cc dbus jpeg libmng libpng openssl tiff zlib

qt_BUILD := \
    $(subst -accessibility ,-no-accessibility ,\
    $(subst -qt-sql-,-no-sql-,\
    $(qt_BUILD)))

qt_BUILD_SHARED := \
    $(subst -static ,-shared ,\
    $(subst -no-webkit ,-webkit ,\
    $(qt_BUILD)))
```

Note the order of inclusion is indeterminate so multiple plugins should not
be chained or attempt to add/modify the same package.
