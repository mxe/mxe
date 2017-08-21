#!/usr/bin/env python

""" Download MXE packages from https://s3.amazonaws.com/mxe-pkg/
"""

import argparse
import hashlib
import os
import urllib
try:
    import urllib2
except:
    # Python 3
    import urllib.request as urllib2
import xml.etree.ElementTree

def get_files():
    x = xml.etree.ElementTree.fromstring(
        urllib2.urlopen("https://s3.amazonaws.com/mxe-pkg/").read()
    )
    for e in x:
        if not e.tag.endswith('Contents'):
            continue
        filename = None
        md5 = None
        for child in e.getchildren():
            if child.tag.endswith('Key'):
                filename = child.text
            if child.tag.endswith('ETag'):
                md5 = child.text.replace('"', '')
        if '-' in md5:
            md5 = None
        yield {
            'filename': filename,
            'md5': md5,
        }

def download_files(backup_dir, files):
    for f in files:
        url = "https://s3.amazonaws.com/mxe-pkg/%s" % (
            urllib.quote(f['filename'])
        )
        data = urllib2.urlopen(url).read()
        if f['md5']:
            md5 = hashlib.md5(data).hexdigest()
            if md5 != f['md5']:
                raise Exception("md5 mismatch for " + f['filename'])
        sha256 = hashlib.sha256(data).hexdigest()
        name = f['filename'] + '_' + sha256
        full_name = os.path.join(backup_dir, name)
        if os.path.exists(full_name):
            print("File %s is already backuped" % name)
            continue
        print("Backup file %s" % name)
        with open(full_name, 'w') as f:
            f.write(data)

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
    files = get_files()
    download_files(args.backup_dir, files)

if __name__ == '__main__':
    main()
