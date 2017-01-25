# Notes about GCC version 4.9.4

GCC 4.9.4 was used before [GCC 5.4.0](https://github.com/mxe/mxe/pull/1541).
This plugin is a backup in case of problems with GCC 5.4.0.

The only package known not to work with this plugin is hyperscan.
It was changed to work with GCC 5.4.0 (`-latomic` was added) and
that change broke support of GCC 4.9.4.
See [the comment](https://github.com/mxe/mxe/pull/1541#issuecomment-274389620).
