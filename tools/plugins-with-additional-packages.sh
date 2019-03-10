#!/usr/bin/env bash

# This file is part of MXE. See LICENSE.md for licensing information.

# List of dirs of plugins with additional packages
# as opposed to customisation plugins.
# See plugins/README.md for more information.

# gcc plugins override each other and end up with errors
echo plugins/{apps,go,luarocks,native,tcl.tk}
