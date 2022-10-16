#!/bin/bash
#
#  MXE GITHUB UPDATE SCRIPT
#  Copyright (C) 2022 Jonas Kvinge
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

function timestamp() { date '+%Y-%m-%d %H:%M:%S'; }
function status() { echo "[$(timestamp)] $*"; }
function error() { echo "[$(timestamp)] ERROR: $*" >&2; }

function update_repo() {

  git fetch >/dev/null 2>&1 || exit 1
  if [ $? -ne 0 ]; then
    error "Could not fetch"
    exit 1
  fi

  git checkout . >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    error "Could not checkout ."
    exit 1
  fi

  if ! [ "$(git branch | head -1 | cut -d ' ' -f2)" = "master" ]; then
    git checkout master >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      error "Could not checkout master branch."
      exit 1
    fi
  fi

  git pull origin master --rebase >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    error "Could not pull with rebase ."
    exit 1
  fi

}

function merge_prs() {

  local prs
  local pr
  local review_decision
  local status_check_rollup
  local status_check_ok
  local status_check_total

  prs=$(gh pr list --json number | jq '.[].number')
  if [ "${prs}" = "" ]; then
    return
  fi

  for pr in ${prs}; do
    if ! [ "$(gh pr view "${pr}" --json 'author' | jq -r '.author.login')" = "${gh_username}" ]; then
      continue
    fi
    if ! [ "$(gh pr view "${pr}" --json 'isDraft' | jq '.isDraft')" = "false" ]; then
      continue
    fi
    if ! [ "$(gh pr view "${pr}" --json 'mergeable' | jq -r '.mergeable')" = "MERGEABLE" ]; then
      continue
    fi
    if ! [ "$(gh pr view "${pr}" --json 'mergeStateStatus' | jq -r '.mergeStateStatus')" = "CLEAN" ]; then
      continue
    fi
    review_decision=$(gh pr view "${pr}" --json 'reviewDecision' | jq -r '.reviewDecision')
    if [ ! "${review_decision}" = "" ] && [ ! "${review_decision}" = "APPROVED" ] ; then
      continue
    fi
    status_check_rollup=$(gh pr view "${pr}" --json 'statusCheckRollup')
    status_check_ok="1"
    status_check_total=$(echo "${status_check_rollup}" | jq '.statusCheckRollup | length')
    for ((i = 0; i < status_check_total; i++)); do
      status_check=$(echo "${status_check_rollup}" | jq -r ".statusCheckRollup[${i}].status")
      if ! [ "${status_check}" = "COMPLETED" ]; then
        status_check_ok=0
        break
      fi
    done
    if ! [ "${status_check_ok}" = "1" ]; then
      continue
    fi
    status "Merging pull request ${pr}."
    gh pr merge -dr "${pr}"
  done

}

function update_packages() {

  make update
  #if [ $? -ne 0 ]; then
  #  echo "make update failed :("
  #  exit 1
  #fi

  package_files=$(git ls-files src/*.mk --modified || exit 1)
  if [ "${package_files}" = "" ]; then
    return
  fi

  for package_file in ${package_files}; do

    package_name=$(grep '^PKG\s*:= ' "${package_file}" | sed -e 's/^PKG\s*:= \(.*\)/\1/' || exit 1)
    if [ "${package_name}" = "" ]; then
      continue
    fi

    # Ignore qt6 packages except qt6-qtbase
    if [ ! "$(echo "${package_name}" | grep '^qt6-')" = "" ] && [ "$(echo "${package_name}" | grep '^qt6-qtbase$')" = "" ]; then
      continue
    fi

    # Ignore gstreamer plugins
    if [ ! "$(echo "${package_name}" | grep -e '^gst-plugins-' -e '^gst-libav$')" = "" ]; then
      continue
    fi

    update_package "${package_file}"

    if ! [ "$(git branch | head -1 | cut -d ' ' -f2)" = "master" ]; then
      git checkout master >/dev/null 2>&1
      if [ $? -ne 0 ]; then
        error "Could not checkout master branch."
        return
      fi
    fi

  done

}

function update_package() {

  local package_file
  local package_name
  local package_version
  local package_branch
  local package_shortname
  local package_files

  package_file="${1}"

  package_name=$(grep '^PKG\s*:= ' "${package_file}" | sed -e 's/^PKG\s*:= \(.*\)/\1/' || exit 1)
  if [ "${package_name}" = "" ]; then
    error "Could not get package name for ${package_file}"
    return
  fi

  package_version=$(grep '$(PKG)_VERSION\s\+:=\s\+' "${package_file}" | sed -e 's/^\$(PKG)_VERSION\s\+:=\s\+\(.*\)/\1/' || exit 1)
  if [ "${package_version}" = "" ]; then
    error "Could not get package version for ${package_file}"
    return
  fi

  # Make sure we have a checksum, otherwise the update failed.
  grep '^\$(PKG)_CHECKSUM\s\+:=\s\+$' "${package_file}" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    error "Skipping ${package_name} (${package_file}), invalid checksum."
    git checkout "${package_file}"
    return
  fi

  if [ "${package_name}" = "qt6-qtbase" ]; then
    package_shortname="qt6"
    package_files=$(git ls-files src/qt6-*.mk --modified | tr '\n' ' ')
  elif [ "${package_name}" = "gstreamer" ]; then
    package_shortname="${package_name}"
    package_files="${package_file} $(git ls-files src/gst-*.mk --modified | tr '\n' ' ')"
  else
    package_shortname="${package_name}"
    package_files="${package_file}"
  fi

  package_branch="${package_shortname}_$(echo ${package_version} | sed 's/\./_/g')"

  git branch | grep "${package_branch}" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    status "Skipping ${package_shortname} (${package_files}), branch for version ${package_version} already exists."
    git checkout ${package_files}
    return
  fi

  status "${package_shortname}: ${package_version}"
  git checkout -b "${package_branch}" || exit 1
  git add ${package_files} || exit 1
  git commit -m "Update ${package_shortname}" ${package_files} || exit 1
  git push origin "${package_branch}" || exit 1
  gh pr create --repo "${repo}" --head "${package_branch}" --base "master" --title "Update ${package_shortname} to ${package_version}" --body "Update ${package_shortname} to ${package_version}" || exit 1
  if ! [ "$(git branch | head -1 | cut -d ' ' -f2)" = "master" ]; then
    git checkout master >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      error "Could not checkout master branch."
      exit 1
    fi
  fi

}

function cleanup() {

  rm -rf log/*
  # Remove downloaded packages every month.
  if [ "$(date +%d)" = "01" ]; then
    rm -f pkg/*
  fi

}

cmds="dirname cat head tail cut sort tr grep sed rm wget curl jq git gh"
cmds_missing=
for cmd in ${cmds}; do
  which "${cmd}" >/dev/null 2>&1
  if [ $? -eq 0 ] ; then
    continue
  fi
  if [ "${cmds_missing}" = "" ]; then
    cmds_missing="${cmd}"
  else
    cmds_missing="${cmds_missing}, ${cmd}"
  fi
done

if ! [ "${cmds_missing}" = "" ]; then
  error "Missing ${cmds_missing} commands."
  exit 1
fi

dir="$(dirname "$0")"

if [ "${dir}" = "" ]; then
  error "Could not get current directory."
  exit 1
fi

if ! [ -d "${dir}" ]; then
  error "Missing ${dir}"
  exit 1
fi

if ! [ -d "${dir}/../.git" ]; then
  error "Missing ${dir}/../.git"
  exit 1
fi

if ! [ -f "${dir}/../Makefile" ]; then
  error "Missing ${dir}/../Makefile"
  exit 1
fi

repodir="$(dirname "${dir}")"

if ! [ -d "${repodir}" ]; then
  error "Missing ${repodir}."
  exit 1
fi

cd "${repodir}"
if [ $? -ne 0 ]; then
  error "Could not change directory to ${repodir}."
  exit 1
fi

repo=$(git config --get remote.origin.url | cut -d ':' -f 2 | sed 's/\.git$//g')
if [ "${repo}" = "" ]; then
  error "Could not get repo name."
  exit 1
fi

git status >/dev/null
if [ $? -ne 0 ]; then
  error "Git status failed."
  exit 1
fi

gh auth status >/dev/null
if [ $? -ne 0 ]; then
  error "Missing GitHub login."
  exit 1
fi

gh_username=$(sed -n 's,^[ ]*user: \(.*\)$,\1,p' ~/.config/gh/hosts.yml)
if [ "${gh_username}" = "" ]; then
  error "Missing GitHub username."
  exit 1
fi

update_repo
merge_prs

update_repo
update_packages

update_repo

cleanup
