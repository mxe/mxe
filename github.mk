# This file is part of MXE. See LICENSE.md for licensing information.

# Standardise GitHub downloads and updates
# Download API has two forms:
#   Archive:
#     url = <owner>/<repo>/archive/<ref>.tar.gz
#     dir = <repo>-<ref>
#
#   Tarball:
#     url = <owner>/<repo>/tarball/<ref>/output-file.tar.gz
#     dir = <owner>-<repo>-<short sha>
#
## also third api - `releases` see libass.mk
#
# Filename doesn't matter as we stream the url to a name of our choosing.
#
# The archive API could be used for all packages, however, if the reference
# is any sort of SHA, the full SHA is used for the directory. We could `cd`
# into it without knowing the SHA beforehand, but the directory length would
# be comical in logs etc.
#
# The tarball API accepts references to commits or tags, always using the
# short SHA as the directory. In this case, tag tracking packages would have
# to store the SHA (see #1002). However, this only works for lightweight
# tags, not annotated tags that most projects use for releases.
#
# In summary, we have to use both.

# The tarball API determines the short SHA length used in the directory name.
# Chances of a collision on a "given" commit seem to decrease as the chance
# of "any" collision increases. If that changes in the future, `make update`
# will fix it.
# Currently (2015-12) the API sets the short SHA length to:
GITHUB_SHA_LENGTH := 7

# Packages must set the following metadata:
#   Track branch - Tarball API
#     GH_CONF := owner/repo/branch
#     updates will use the last commit from the specified branch as
#     a version string and bypass `sort -V`
#
#   Track tags - Archive API
#     GH_CONF := owner/repo, tag prefix, tag suffix, tag filter-out, version separator
#     updates will construct a version number based on:
#     <tag prefix><s/<version sep>/./version><tag suffix>

# common tag filtering is applied with `grep -v`:
GITHUB_TAG_FILTER := alpha\|beta\|rc

# More complex filters can fall back to `MXE_GET_GH_TAGS` which returns
# a list for post-processing.

# ...and finally, auto-configure packages based on above metadata:
#   - `eval` these snippets during PKG_RULE loop (where PKG is in scope).
#   - `call` or `eval` from package makefiles requires complex quoting
#     and looks out of place.
#   - don't redefine manually set standard variables (FILE, SUBDIR, URL, UPDATE)

GH_REPO        = $(subst $(space),/,$(wordlist 1,2,$(subst /,$(space),$(subst $(comma),$(space),$($(PKG)_GH_CONF)))))
GH_BRANCH      = $(word 3,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF)))))
GH_TAG_VARS    = $(call rest,$(subst $(comma),$(space)$(__gmsl_aa_magic),$(subst $(space),,$($(PKG)_GH_CONF))))
GH_TAG_PREFIX  = $(subst $(__gmsl_aa_magic),,$(word 1,$(GH_TAG_VARS)))
GH_TAG_SUFFIX  = $(subst $(__gmsl_aa_magic),,$(word 2,$(GH_TAG_VARS)))
GH_TAG_FILTER  = $(subst $(__gmsl_aa_magic),,$(word 3,$(GH_TAG_VARS)))
GH_VERSION_SEP = $(subst $(__gmsl_aa_magic),,$(word 4,$(GH_TAG_VARS)))

define MXE_SETUP_GITHUB
    $(PKG)_GH_REPO     := $(GH_REPO)
    $(PKG)_BRANCH      := $(GH_BRANCH)
    $(PKG)_TAG_VARS    := $(GH_TAG_VARS)
    $(PKG)_TAG_PREFIX  := $(GH_TAG_PREFIX)
    $(PKG)_TAG_SUFFIX  := $(GH_TAG_SUFFIX)
    $(PKG)_TAG_FILTER  := $(GH_TAG_FILTER)
    $(PKG)_VERSION_SEP := $(or $(GH_VERSION_SEP),.)
    $(PKG)_FILE        := $(or $($(PKG)_FILE),$(PKG)-$$($$(PKG)_TAG_PREFIX)$($(PKG)_VERSION)$$($$(PKG)_TAG_SUFFIX).tar.gz)
    $(if $(and $(GH_BRANCH),$(GH_TAG_VARS)),\
        $(error $(newline) $(PKG) specifies both branch and tag variables $(newline)))
    $(if $(GH_BRANCH),$(value MXE_SETUP_GITHUB_BRANCH),$(value MXE_SETUP_GITHUB_TAG))
endef

define MXE_SETUP_GITHUB_BRANCH
    $(PKG)_SUBDIR := $(or $($(PKG)_SUBDIR),$(subst /,-,$($(PKG)_GH_REPO))-$($(PKG)_VERSION))
    $(PKG)_URL    := $(or $($(PKG)_URL),https://github.com/$($(PKG)_GH_REPO)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE))
    $(PKG)_UPDATE := $(or $($(PKG)_UPDATE),$(call MXE_GET_GH_SHA,$($(PKG)_GH_REPO),$($(PKG)_BRANCH)))
endef

define MXE_SETUP_GITHUB_TAG
    $(PKG)_SUBDIR := $(or $($(PKG)_SUBDIR),$(PKG)-$($(PKG)_TAG_PREFIX)$(subst .,$($(PKG)_VERSION_SEP),$($(PKG)_VERSION))$($(PKG)_TAG_SUFFIX))
    $(PKG)_URL    := $(or $($(PKG)_URL),https://github.com/$($(PKG)_GH_REPO)/archive/$(subst $(PKG)-,,$($(PKG)_SUBDIR)).tar.gz)
    $(PKG)_UPDATE := $(or $($(PKG)_UPDATE),$(call MXE_GET_GH_TAG,$($(PKG)_GH_REPO),$($(PKG)_TAG_PREFIX),$($(PKG)_TAG_SUFFIX),$(or $($(PKG)_TAG_FILTER),$(GITHUB_TAG_FILTER)),$($(PKG)_VERSION_SEP)))
endef

# called with owner/repo,branch
define MXE_GET_GH_SHA
    $(WGET) -q -O- 'https://api.github.com/repos/$(strip $(1))/git/refs/heads/$(strip $(2))' \
    | $(SED) -n 's#.*"sha": "\([^"]\{$(GITHUB_SHA_LENGTH)\}\).*#\1#p' \
    | head -1
endef

# called with owner/repo
define MXE_GET_GH_TAGS
    $(WGET) -q -O- 'https://api.github.com/repos/$(strip $(1))/git/refs/tags/' \
    | $(SED) -n 's#.*"ref": "refs/tags/\([^"]*\).*#\1#p'
endef

# called with owner/repo, tag prefix, tag suffix, filter-out, version sep
define MXE_GET_GH_TAG
    $(MXE_GET_GH_TAGS) \
    | $(if $(4),grep -v '$(strip $(4))') \
    | $(SED) -n 's,^$(strip $(2))\([^"]*\)$(strip $(3))$$,\1,p' \
    | tr '$(strip $(5))' '.' \
    | $(SORT) -V
    | tail -1
endef
