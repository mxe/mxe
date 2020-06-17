# This file is part of MXE. See LICENSE.md for licensing information.

# Standardise GitHub downloads and updates
# Download API has three forms:
#   Archive:
#     url = <owner>/<repo>/archive/<ref>.tar.gz
#     dir = <repo>-<ref>
#       if <ref> starts with a single `v`, it is removed from dir
#
#   Release:
#     Manually uploaded distribution tarballs, especially useful for
#     autotools packages with generated sources. No universal convention,
#     but the default is:
#     url = <owner>/<repo>/releases/downloads/<ref>/<repo>-<version>.[archive extension] | tar.gz
#     dir = <repo>-<version>
#
#
#   Tarball:
#     url = <owner>/<repo>/tarball/<ref>/output-file.tar.gz
#     dir = <owner>-<repo>-<short sha>

# Filename doesn't matter as we stream the url to a name of our choosing.
#
# The archive API could be used for all packages, however, if the reference
# is any sort of SHA, the full SHA is used for the directory. We could `cd`
# into it without knowing the SHA beforehand, but the directory length would
# be comical in logs etc.
#
# The release API is based on tags but the uploaded tarballs may use
# any naming convention for the filename and subdir, and also other
# archive types e.g. *.xz
#
# The tarball API accepts references to commits or tags, always using the
# short SHA as the directory. In this case, tag tracking packages would have
# to store the SHA (see #1002). However, this only works for lightweight
# tags, not annotated tags that most projects use for releases.
#
# In summary, we have to use all three.


# The tarball API determines the short SHA length used in the directory name.
# Chances of a collision on a "given" commit seem to decrease as the chance
# of "any" collision increases. If that changes in the future, `make update`
# will fix it.
# Currently (2015-12) the API sets the short SHA length to:
GITHUB_SHA_LENGTH := 7

# Packages must set the following metadata:
#   Track branch - Tarball API
#     GH_CONF := owner/repo/branches/branch
#     updates will use the last commit from the specified branch as
#     a version string and bypass `sort -V`
#
#   Track releases - Release API
#     GH_CONF := owner/repo/releases[/latest], tag prefix, tag suffix, tag filter-out, version separator, archive extension
#     updates can optionally use the latest non-prerelease with /latest
#     or manually specify version numbering based on:
#     <tag prefix><s/<version sep>/./version><tag suffix>
#
#   Track tags - Archive API
#     GH_CONF := owner/repo/tags, tag prefix, tag suffix, tag filter-out, version separator
#     updates will construct a version number based on:
#     <tag prefix><s/<version sep>/./version><tag suffix>
#
GH_APIS := branches releases tags

# common tag filtering is applied with `grep -v`:
GITHUB_TAG_FILTER := alpha\|beta\|rc

# More complex filters can fall back to `MXE_GET_GH_TAGS` which returns
# a list for post-processing.

# ...and finally, auto-configure packages based on above metadata:
#   - `eval` these snippets during PKG_RULE loop (where PKG is in scope).
#   - `call` or `eval` from package makefiles requires complex quoting
#     and looks out of place.
#   - don't redefine manually set standard variables (FILE, SUBDIR, URL, UPDATE)

GH_OWNER       = $(word 1,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF)))))
GH_REPO        = $(word 2,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF)))))
GH_API         = $(word 3,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF)))))
GH_BRANCH      = $(and $(filter branches,$(GH_API)),$(word 4,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF))))))
GH_LATEST      = $(and $(filter releases,$(GH_API)),$(word 4,$(subst /,$(space),$(word 1,$(subst $(comma),$(space),$($(PKG)_GH_CONF))))))
GH_TAG_VARS    = $(call rest,$(subst $(comma),$(space)$(__gmsl_aa_magic),$(subst $(space),,$($(PKG)_GH_CONF))))
GH_TAG_PREFIX  = $(subst $(__gmsl_aa_magic),,$(word 1,$(GH_TAG_VARS)))
GH_TAG_SUFFIX  = $(subst $(__gmsl_aa_magic),,$(word 2,$(GH_TAG_VARS)))
GH_TAG_FILTER  = $(subst $(__gmsl_aa_magic),,$(word 3,$(GH_TAG_VARS)))
GH_VERSION_SEP = $(subst $(__gmsl_aa_magic),,$(word 4,$(GH_TAG_VARS)))
GH_ARCHIVE_EXT = $(subst $(__gmsl_aa_magic),,$(word 5,$(GH_TAG_VARS)))

define MXE_SETUP_GITHUB
    $(PKG)_GH_OWNER    := $(GH_OWNER)
    $(PKG)_GH_REPO     := $(GH_REPO)
    $(PKG)_GH_LATEST   := $(if $(GH_LATEST),/latest)
    $(PKG)_BRANCH      := $(GH_BRANCH)
    $(PKG)_TAG_VARS    := $(GH_TAG_VARS)
    $(PKG)_TAG_PREFIX  := $(GH_TAG_PREFIX)
    $(PKG)_TAG_SUFFIX  := $(GH_TAG_SUFFIX)
    $(PKG)_TAG_FILTER  := $(GH_TAG_FILTER)
    $(PKG)_VERSION_SEP := $(or $(GH_VERSION_SEP),.)
    $(PKG)_ARCHIVE_EXT := $(or $(GH_ARCHIVE_EXT),.tar.gz)
    $(PKG)_FILE        := $(or $($(PKG)_FILE),$(PKG)-$$(filter-out $$(PKG)-,$$($$(PKG)_TAG_PREFIX))$($(PKG)_VERSION)$$($$(PKG)_TAG_SUFFIX)$$($$(PKG)_ARCHIVE_EXT))
    $(if $(and $(GH_BRANCH),$(GH_TAG_VARS)),\
        $(error $(newline) $(PKG) specifies both branch and tag variables $(newline)))
    $(if $(filter-out $(GH_APIS),$(GH_API))$(filter x,x$(GH_API)),\
        $(error $(newline) $(PKG) has unknown API in GH_CONF := $($(PKG)_GH_CONF) $(newline)\
                           must be $(call merge,|,$(GH_APIS))))
    $(value MXE_SETUP_GITHUB_$(call uc,$(GH_API)))
endef

define MXE_SETUP_GITHUB_BRANCHES
    $(PKG)_SUBDIR := $(or $($(PKG)_SUBDIR),$($(PKG)_GH_OWNER)-$($(PKG)_GH_REPO)-$($(PKG)_VERSION))
    $(PKG)_URL    := $(or $($(PKG)_URL),https://github.com/$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE))
    $(PKG)_UPDATE := $(or $($(PKG)_UPDATE),$(call MXE_GET_GH_SHA,$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO),$($(PKG)_BRANCH)))
endef

define MXE_SETUP_GITHUB_RELEASES
    $(PKG)_SUBDIR  := $(or $($(PKG)_SUBDIR),$($(PKG)_GH_REPO)-$(if $(call sne,v,$($(PKG)_TAG_PREFIX)),$($(PKG)_TAG_PREFIX))$(subst .,$($(PKG)_VERSION_SEP),$($(PKG)_VERSION))$($(PKG)_TAG_SUFFIX))
    $(PKG)_TAG_REF := $(or $($(PKG)_TAG_REF),$($(PKG)_TAG_PREFIX)$(subst .,$($(PKG)_VERSION_SEP),$($(PKG)_VERSION))$($(PKG)_TAG_SUFFIX))
    $(PKG)_URL     := $(or $($(PKG)_URL),https://github.com/$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO)/releases/download/$($(PKG)_TAG_REF)/$($(PKG)_SUBDIR)$($(PKG)_ARCHIVE_EXT))
    $(PKG)_URL_2   := $(or $($(PKG)_URL_2),https://github.com/$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO)/archive/$($(PKG)_TAG_REF).tar.gz)
    $(PKG)_UPDATE  := $(or $($(PKG)_UPDATE),$(call MXE_GET_GH_RELEASE,$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO)/releases$($(PKG)_GH_LATEST),$($(PKG)_TAG_PREFIX),$($(PKG)_TAG_SUFFIX),$(or $($(PKG)_TAG_FILTER),$(GITHUB_TAG_FILTER)),$($(PKG)_VERSION_SEP)))
endef

define MXE_SETUP_GITHUB_TAGS
    $(PKG)_SUBDIR := $(or $($(PKG)_SUBDIR),$($(PKG)_GH_REPO)-$(if $(call sne,v,$($(PKG)_TAG_PREFIX)),$($(PKG)_TAG_PREFIX))$(subst .,$($(PKG)_VERSION_SEP),$($(PKG)_VERSION))$($(PKG)_TAG_SUFFIX))
    $(PKG)_TAR_GZ := $(or $($(PKG)_TAR_GZ),$($(PKG)_TAG_PREFIX)$(subst .,$($(PKG)_VERSION_SEP),$($(PKG)_VERSION))$($(PKG)_TAG_SUFFIX))
    $(PKG)_URL    := $(or $($(PKG)_URL),https://github.com/$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO)/archive/$($(PKG)_TAR_GZ).tar.gz)
    $(PKG)_UPDATE := $(or $($(PKG)_UPDATE),$(call MXE_GET_GH_TAG,$($(PKG)_GH_OWNER)/$($(PKG)_GH_REPO),$($(PKG)_TAG_PREFIX),$($(PKG)_TAG_SUFFIX),$(or $($(PKG)_TAG_FILTER),$(GITHUB_TAG_FILTER)),$($(PKG)_VERSION_SEP)))
endef

# called with owner/repo/releases[/latest],tag prefix, tag suffix, filter-out, version sep
define MXE_GET_GH_RELEASE
    $(WGET) -q -O- 'https://github.com/$(strip $(1))' \
    | $(SED) -n 's,.*releases/tag/\([^"&;]*\)".*,\1,p' \
    | $(if $(4),grep -vi '$(strip $(4))') \
    | $(SED) -n 's,^$(strip $(2))\([^"]*\)$(strip $(3))$$,\1,p' \
    | tr '$(strip $(5))' '.' \
    | $(SORT) -V \
    | tail -1
endef

# called with owner/repo,branch
define MXE_GET_GH_SHA
    $(WGET) -q -O- 'https://api.github.com/repos/$(strip $(1))/git/refs/heads/$(strip $(2))' \
    | $(SED) -n 's#.*"sha": "\([^"]\{$(GITHUB_SHA_LENGTH)\}\).*#\1#p' \
    | head -1
endef

# called with owner/repo
define MXE_GET_GH_TAGS
    $(WGET) -q -O- 'https://github.com/$(strip $(1))/tags' \
    | $(SED) -n 's#.*releases/tag/\([^"]*\).*#\1#p'
endef

# called with owner/repo, tag prefix, tag suffix, filter-out, version sep
define MXE_GET_GH_TAG
    $(MXE_GET_GH_TAGS) \
    | $(if $(4),grep -vi '$(strip $(4))') \
    | $(SED) -n 's,^$(strip $(2))\([^"]*\)$(strip $(3))$$,\1,p' \
    | tr '$(strip $(5))' '.' \
    | $(SORT) -V \
    | tail -1
endef

GITHUB_PKGS = $(patsubst %_GH_CONF,%,$(filter %_GH_CONF,$(.VARIABLES)))

# test downloads, updates, and source directory
# make check-gh-conf MXE_PLUGIN_DIRS="`find plugins -name '*.mk' -print0 | xargs -0 -n1 dirname | sort | uniq | tr '\n' ' '`"

# a test of many package updates may hit rate limit of 60/hr
# https://developer.github.com/v3/#rate-limiting

.PHONY: check-gh-conf check-gh-conf-%
check-gh-conf-pkg-%: check-update-package-%
	@$(MAKE) -f '$(MAKEFILE)' 'download-only-$(*)' \
	    REMOVE_DOWNLOAD=true \
	    MXE_NO_BACKUP_DL=true \
	    --no-print-directory
	@$(PRINTF_FMT) '[prep-src]'  '$(*)' | $(RTRIM)
	@($(MAKE) -f '$(MAKEFILE)' 'prepare-pkg-source-$(*)') &> '$(LOG_DIR)/$(*)-prep-src'
	@rm -rf '$(call TMP_DIR,$(*))'

# secondexpansion here since this file is included before pkg makefiles
.SECONDEXPANSION:
check-gh-conf: $$(addprefix check-gh-conf-pkg-,$$(GITHUB_PKGS))
github-pkgs: $$(GITHUB_PKGS)
