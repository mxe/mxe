Freezing Qt5 version
--------------------------------

This plugin demonstrates freezing a version of Qt5 in a local plugin,
possibly for Win XP support (see #1827, #1734). It's possible to simply
stay on a git checkout, but then other toolchain features are also
frozen.

*N.B.* This is unsupported and exists solely as an example of how one
might maintain a local version.

##### Overview

Basic outline is to checkout a version, copy the makefile and patches,
and lock the patches to the ones in this directory instead of core
MXE src:

```
export PLUGIN_DIR=plugins/examples/qt5-freeze
rm -rf $PLUGIN_DIR
mkdir -p $PLUGIN_DIR

# parent of Qt 5.8 update
git checkout a0f9e61

# find all Qt5 modules and copy
export QT5_PKGS=`grep -l qtbase_VERSION src/*.mk | sed -n 's,src/\(.*\)\.mk.*,\1,p' | tr '\n' ','`
export QT5_PKGS=${QT5_PKGS}qtbase
cp `eval echo src/{$QT5_PKGS}.mk` $PLUGIN_DIR
cp `eval echo src/{$QT5_PKGS}-*.patch` $PLUGIN_DIR

# set $(PKG)_PATCHES to only look for patches in the current directory
# on macos, use `gsed` instead of `sed`
find $PLUGIN_DIR -name "qt[^5]*.mk" -exec sed -i '9i$(PKG)_PATCHES  := $(realpath $(sort $(wildcard $(dir $(lastword $(MAKEFILE_LIST)))/$(PKG)-[0-9]*.patch)))' {} \;
git checkout master
```

Now you'll have all the right versions, just some minor changes since
`mysql` doesn't support XP (see #1394). In a real local scenario, the
package should also be removed from `$(PKG)_DEPS` and `qtbase.mk`
modified. `MXE_PLUGIN_DIRS` can also be added to `settings.mk`

```
make qt5 MXE_PLUGIN_DIRS=$PLUGIN_DIR qtbase_CONFIGURE_OPTS='-no-sql-mysql'

```
