#!/usr/bin/env python

""" Create a skeleton of new MXE package.

This file is part of MXE. See LICENSE.md for licensing information.
"""

import argparse
import hashlib
import os
import re
import shutil
import subprocess
import tempfile
try:
    import urllib2
except:
    # Python 3
    import urllib.request as urllib2

MK_TEMPLATE = r'''
# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := %(name)s
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := %(version)s
$(PKG)_CHECKSUM := %(checksum)s
$(PKG)_SUBDIR   := %(subdir_template)s
$(PKG)_FILE     := %(filename_template)s
$(PKG)_URL      := %(file_url_template)s
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'TODO: write update script for %(name)s.' >&2;
    echo $(%(name)s_VERSION)
endef

define $(PKG)_BUILD
    %(build)s
endef
'''

CMAKE_BUILD = r'''
    # build and install the library
    cd '$(BUILD_DIR)' && $(TARGET)-cmake \
        '$(SOURCE_DIR)'
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
'''

AUTOTOOLS_BUILD = r'''
    # build and install the library
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS=
'''

MAKE_BUILD = r'''
    # build and install the library
    $(MAKE) -C '$(SOURCE_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(SOURCE_DIR)' -j 1 install
'''

BUILDERS = {
    'autotools': AUTOTOOLS_BUILD,
    'make': MAKE_BUILD,
    'cmake': CMAKE_BUILD,
}

PC_AND_TEST = r'''
    # create pkg-config files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: %(description)s'; \
     echo 'Libs: -l%(libname)s';) \
     > '$(PREFIX)/$(TARGET)/lib/pkgconfig/$(PKG).pc'

    # compile test
    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        `'$(TARGET)-pkg-config' $(PKG) --cflags --libs`
'''

def get_filename(file_url):
    return file_url.rsplit('/', 1)[1]

def deduce_version(file_url):
    filename = get_filename(file_url)
    return re.search(r'\d[\d.-_]+\d|\d', filename).group()

def deduce_website(file_url):
    return file_url.split('://', 1)[1].split('/', 1)[0]

def download_file(destination, url):
    with open(destination, 'wb') as d:
        request =  urllib2.urlopen(url)
        shutil.copyfileobj(request, d)
        request.close()

def make_checksum(filepath):
    hasher = hashlib.sha256()
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(1024 ** 2), b''):
            hasher.update(chunk)
    return hasher.hexdigest()

def deduce_subdir(archive):
    args = ['tar', '-tf', archive]
    tar = subprocess.Popen(args, stdout=subprocess.PIPE)
    output = tar.communicate()[0]
    if not isinstance(output, str):
        # Python 3
        output = output.decode()
    files = output.strip().split('\n')
    first_file = files[0].strip()
    directory = first_file.split('/', 1)[0]
    return directory

def make_build(options, builder):
    commands_template = BUILDERS[builder].lstrip() + PC_AND_TEST.rstrip()
    return commands_template % options

def update_index_html(name, description, website):
    # read HTML and find a list of packages
    with open('docs/index.html', 'rb') as f:
        index_html = f.read()
        if not isinstance(index_html, str):
            # Python 3
            index_html = index_html.decode()
    sep1 = '    <table id="package-list" class="old">'
    sep2 = '    </table>'
    (prefix, other) = index_html.split(sep1, 1)
    (packages_html, suffix) = other.split(sep2, 1)
    # find existing packages
    pkg_re = r'''
    <tr>
        <td class="package">(?P<name>.*)</td>
        <td class="website"><a href="(?P<website>.*)">(?P<description>.*)</a></td>
    </tr>
    '''.strip()
    packages = [
        {
            'name': match.group('name'),
            'description': match.group('description'),
            'website': match.group('website'),
        }
        for match in re.finditer(pkg_re, packages_html)
    ]
    packages.append({
        'name': name,
        'description': description,
        'website': website,
    })
    packages.sort(key=lambda package: package['name'])
    pkg_template = r'''
    <tr>
        <td class="package">%(name)s</td>
        <td class="website"><a href="%(website)s">%(description)s</a></td>
    </tr>
    '''.rstrip()
    packages_html = ''.join(pkg_template % package for package in packages)
    packages_html += '\n'
    # build and write HTML
    index_html = prefix + sep1 + packages_html + sep2 + suffix
    (_, tmp_index_html) = tempfile.mkstemp()
    with open(tmp_index_html, 'wt') as f:
        f.write(index_html)
    os.rename(tmp_index_html, 'docs/index.html')

def make_skeleton(
    name,
    description,
    file_url,
    version,
    subdir,
    website,
    builder,
):
    mk_filename = 'src/%s.mk' % name
    if os.path.isfile(mk_filename):
        raise Exception('File %s exists!' % mk_filename)
    if description is None:
        description = name
    if version is None:
        version = deduce_version(file_url)
    if website is None:
        website = deduce_website(file_url)
    with tempfile.NamedTemporaryFile() as pkg_file:
        download_file(pkg_file.name, file_url)
        checksum = make_checksum(pkg_file.name)
        if subdir is None:
            subdir = deduce_subdir(pkg_file.name)
    filename = get_filename(file_url)
    filename_template = filename.replace(version, '$($(PKG)_VERSION)')
    file_url_template = file_url.replace(version, '$($(PKG)_VERSION)')
    subdir_template = subdir.replace(version, '$($(PKG)_VERSION)')
    libname = name
    if libname.startswith('lib'):
        libname = libname[3:]
    with open(mk_filename, 'wt') as mk:
        options = {
            'name': name,
            'description': description,
            'libname': libname,
            'website': website,
            'file_url_template': file_url_template,
            'checksum': checksum,
            'version': version,
            'subdir_template': subdir_template,
            'filename_template': filename_template,
        }
        options['build'] = make_build(options, builder)
        mk.write(MK_TEMPLATE.lstrip() % options)
    update_index_html(name, description, website)

def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        '--name',
        type=str,
        help='Package name',
        required=True,
    )
    parser.add_argument(
        '--file-url',
        type=str,
        help='URL with file of package',
        required=True,
    )
    parser.add_argument(
        '--description',
        type=str,
        help='Package description (defaults to name)',
        required=False,
    )
    parser.add_argument(
        '--version',
        type=str,
        help='Package version (can be deduced from file)',
        required=False,
    )
    parser.add_argument(
        '--subdir',
        type=str,
        help='Package subdir (can be deduced from file)',
        required=False,
    )
    parser.add_argument(
        '--website',
        type=str,
        help='Package website (defaults to domain of file)',
        required=False,
    )
    parser.add_argument(
        '--builder',
        choices=sorted(BUILDERS.keys()),
        help='Template of $(PKG)_BUILD',
        default='autotools',
    )
    args = parser.parse_args()
    make_skeleton(
        args.name,
        args.description,
        args.file_url,
        args.version,
        args.subdir,
        args.website,
        args.builder,
    )

if __name__ == '__main__':
    main()
