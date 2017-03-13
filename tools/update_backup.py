#!/usr/bin/env python

""" Update backup of MXE packages.
"""

import argparse
import hashlib
import os
import shutil

def make_checksum(filepath):
    hasher = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(1024 ** 2), b''):
            hasher.update(chunk)
    return hasher.hexdigest()

def update_backup(mxe_pkg_dir, backup_dir):
    for f in os.listdir(mxe_pkg_dir):
        sha = make_checksum(os.path.join(mxe_pkg_dir, f))
        new_name = '%s_%s' % (f, sha)
        if os.path.exists(os.path.join(backup_dir, new_name)):
            print("File %s is already backuped" % new_name)
            continue
        shutil.copy(
            os.path.join(mxe_pkg_dir, f),
            os.path.join(backup_dir, new_name),
        )
        print("Backup file %s" % new_name)

def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        '--backup-dir',
        type=str,
        help='Path to backup',
        required=True,
    )
    args = parser.parse_args()
    mxe_tools_dir = os.path.dirname(os.path.realpath(__file__))
    mxe_pkg_dir = os.path.join(mxe_tools_dir, '..', 'pkg')
    update_backup(
        mxe_pkg_dir,
        args.backup_dir,
    )

if __name__ == '__main__':
    main()
