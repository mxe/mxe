#!/usr/bin/env python
# -*- coding: utf-8 -*-
# DLL dependency resolution and copying script.
# Copyright (C) 2010 John Stumpo
# Copyright (C) 2014 Martin Müllenhaupt
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

import os
import shutil
import struct
import sys

def is_pe_file(file):
    if not os.path.isfile(file): # Skip directories
        return False
    f = open(file, 'rb')
    if f.read(2) != b'MZ':
        return False  # DOS magic number not present
    f.seek(60)
    peoffset = struct.unpack('<L', f.read(4))[0]
    f.seek(peoffset)
    if f.read(4) != b'PE\0\0':
        return False  # PE magic number not present
    return True

def get_imports(file):
    f = open(file, 'rb')
    # We already know it's a PE, so don't bother checking again.
    f.seek(60)
    pe_header_offset = struct.unpack('<L', f.read(4))[0]

    # Get sizes of tables we need.
    f.seek(pe_header_offset + 6)
    number_of_sections = struct.unpack('<H', f.read(2))[0]
    f.seek(pe_header_offset + 116)
    number_of_data_directory_entries = struct.unpack('<L', f.read(4))[0]
    data_directory_offset = f.tell()  # it's right after the number of entries

    # Where is the import table?
    f.seek(data_directory_offset + 8)
    rva_of_import_table = struct.unpack('<L', f.read(4))[0]

    # Get the section ranges so we can convert RVAs to file offsets.
    f.seek(data_directory_offset + 8 * number_of_data_directory_entries)
    sections = []
    for i in range(number_of_sections):
        section_descriptor_data = f.read(40)
        name, size, va, rawsize, offset = \
            struct.unpack('<8sLLLL', section_descriptor_data[:24])
        sections.append({'min': va, 'max': va+rawsize, 'offset': offset})

    def seek_to_rva(rva):
        for s in sections:
            if s['min'] <= rva and rva < s['max']:
                f.seek(rva - s['min'] + s['offset'])
                return
        raise ValueError('Could not find section for RVA.')

    # Walk the import table and get RVAs to the null-terminated names of DLLs
    # this file uses. The table is terminated by an all-zero entry.
    seek_to_rva(rva_of_import_table)
    dll_rvas = []
    while True:
        import_descriptor = f.read(20)
        if import_descriptor == b'\0' * 20:
            break
        dll_rvas.append(struct.unpack('<L', import_descriptor[12:16])[0])

    # Read the DLL names from the RVAs we found in the import table.
    dll_names = []
    for rva in dll_rvas:
        seek_to_rva(rva)
        name = b''
        while True:
            c = f.read(1)
            if c == b'\0':
                break
            name += c
        dll_names.append(name.decode("ascii"))

    return dll_names


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description='Recursive copy of DLL dependencies')
    parser.add_argument('targetdir',
                        type=str,
                        help='target directory where to place the DLLs')
    parser.add_argument('-C',
                        '--checkdir',
                        type=str,
                        action='append',
                        nargs='+',
                        default=[],
                        required=True,
                        help='directories whose dependencies must be ' +
                             'fulfilled. All PE files will be checked ' +
                             '(mostly .exe and .dll files)',
                        dest='checkdirs')
    parser.add_argument('-L',
                        '--libdir',
                        type=str,
                        action='append',
                        nargs='+',
                        default=[],
                        required=True,
                        help='include directories to search for DLL ' +
                             'dependencies (only .dll files will be used ' +
                             'from here)',
                        dest='libdirs')
    args = parser.parse_args()

    if sys.version_info < (3, 0):
        from sets import Set as set

    # Map from shortname ('qtcore4.dll') to full path (eg.
    # '/.../mxe/i686-w64-mingw32.shared/qt/bin/QtCore4.dll')
    available_dlls = dict()
    # Remember already copied DLLs (eg 'qtcore4.dll', 'qtgui4.dll')
    copied_dlls    = set()
    # Remember which DLLs must still be checked (eg 'qtnetwork4.dll',
    # 'qtgui4.dll')
    dlls_to_copy   = set()
    not_found_dlls = set()

    # Create a list of all available .dll files in the libdir directories
    # Flattening list: https://stackoverflow.com/questions/952914
    for libdir in [item for sublist in args.libdirs for item in sublist]:
        for dll_filename in os.listdir(libdir):
            dll_filename_full = os.path.join(libdir, dll_filename)
            if dll_filename.endswith('.dll') and is_pe_file(dll_filename_full):
                available_dlls[dll_filename.lower()] = dll_filename_full

    # Create a list of initial dependencies (dlls_to_copy) and already copied
    # DLLs (copied_dlls) from the checkdir arguments.
    # Flattening list: https://stackoverflow.com/questions/952914
    for checkdir in [item for sublist in args.checkdirs for item in sublist]:
        for pe_filename in os.listdir(checkdir):
            pe_filename_full = os.path.join(checkdir, pe_filename)
            if is_pe_file(pe_filename_full):
                for dependency_dll in get_imports(pe_filename_full):
                    dlls_to_copy.add(dependency_dll.lower())
                if pe_filename.endswith('.dll'):
                    copied_dlls.add(pe_filename.lower())

    while len(dlls_to_copy):
        # We may not change the set during iteration
        for dll_to_copy in dlls_to_copy.copy():
            if dll_to_copy in copied_dlls:
                None
            elif dll_to_copy in not_found_dlls:
                None
            elif dll_to_copy in available_dlls:
                shutil.copyfile(available_dlls[dll_to_copy],
                                os.path.join(args.targetdir,
                                os.path.basename(available_dlls[dll_to_copy])))
                copied_dlls.add(dll_to_copy.lower())
                for dependency_dll in get_imports(available_dlls[dll_to_copy]):
                    dlls_to_copy.add(dependency_dll.lower())
            else:
                not_found_dlls.add(dll_to_copy)
            dlls_to_copy.remove(dll_to_copy)
    print("Missing dll files: " + ", ".join(not_found_dlls))
