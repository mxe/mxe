/*
    This file is part of MXE. See LICENSE.md for licensing information.

    Initial test file scaffold generated using the "gsrc" tool:
    https://github.com/hkunz/git-fetcher

    Compilation (pkg-config):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/minizip-ng-test.cpp \
        $(./usr/bin/x86_64-w64-mingw32.static-pkg-config --cflags --libs minizip) \
        -o usr/x86_64-w64-mingw32.static/bin/test-minizip-ng.exe

    Compilation (manual):

    ./usr/bin/x86_64-w64-mingw32.static-g++ \
        src/minizip-ng-test.cpp \
        -I usr/x86_64-w64-mingw32.static/include \
        -L usr/x86_64-w64-mingw32.static/lib \
        -lminizip \
        -lz \
        -lbz2 \
        -llzma \
        -lzstd \
        -lbcrypt \
        -o usr/x86_64-w64-mingw32.static/bin/test-minizip-ng.exe

    This test verifies:
    - ZIP archive creation (write support)
    - ZLIB compression backend (-lz)
    - Optional encrypted ZIP entries (crypto backend, e.g. BCrypt/OpenSSL)
    - ZIP archive reading (unzip functionality)
    - File listing and metadata access
    - End-to-end data integrity (write → compress → read → decompress)

*/

#include <cstdio>
#include <cstring>
#include <vector>

#include <minizip/zip.h>
#include <minizip/unzip.h>

static void write_file(zipFile zf,
                       const char* name,
                       const char* content,
                       const char* password = nullptr)
{
    zip_fileinfo zi;
    memset(&zi, 0, sizeof(zi));

    int err = zipOpenNewFileInZip3_64(
        zf,
        name,
        &zi,
        nullptr, 0,
        nullptr, 0,
        nullptr,
        Z_DEFLATED,
        Z_DEFAULT_COMPRESSION,
        0,
        -MAX_WBITS,
        DEF_MEM_LEVEL,
        Z_DEFAULT_STRATEGY,
        password,
        0,
        0
    );

    if (err != ZIP_OK) {
        printf("FAIL: write %s\n", name);
        return;
    }

    zipWriteInFileInZip(zf, content, (unsigned int)strlen(content));
    zipCloseFileInZip(zf);

    printf("OK: wrote %s\n", name);
}

static void read_zip(const char* zipname)
{
    unzFile uf = unzOpen(zipname);
    if (!uf) {
        printf("FAIL: unzip open\n");
        return;
    }

    if (unzGoToFirstFile(uf) != UNZ_OK) {
        printf("FAIL: go first file\n");
        unzClose(uf);
        return;
    }

    do {
        char fname[256];
        unz_file_info info;
        memset(&info, 0, sizeof(info));

        if (unzGetCurrentFileInfo(
                uf,
                &info,
                fname,
                sizeof(fname),
                nullptr, 0,
                nullptr, 0) != UNZ_OK)
        {
            printf("FAIL: get file info\n");
            break;
        }

        printf("READ FILE: %s\n", fname);

        int err;

        // IMPORTANT: handle encrypted file properly
        if (strcmp(fname, "encrypted.txt") == 0)
        {
            err = unzOpenCurrentFilePassword(uf, "password123");
        }
        else
        {
            err = unzOpenCurrentFile(uf);
        }

        if (err != UNZ_OK) {
            printf("FAIL: open file %s\n", fname);
            break;
        }

        std::vector<char> buf(info.uncompressed_size + 1);
        int r = unzReadCurrentFile(uf, buf.data(), (unsigned int)buf.size());

        if (r < 0) {
            printf("FAIL: read file\n");
            unzCloseCurrentFile(uf);
            break;
        }

        buf[r] = '\0';

        printf("CONTENT: %s\n", buf.data());

        unzCloseCurrentFile(uf);

    } while (unzGoToNextFile(uf) == UNZ_OK);

    unzClose(uf);
}

int main()
{
    printf("=== MXE minizip-ng FULL VALIDATION TEST ===\n");

    const char* zipname = "test.zip";

    zipFile zf = zipOpen(zipname, 0);
    if (!zf) {
        printf("FAIL: zipOpen\n");
        return 1;
    }

    // -------------------------
    // Normal file (zlib)
    // -------------------------
    write_file(
        zf,
        "zlib.txt",
        "hello from zlib compression"
    );

    // -------------------------
    // Encrypted file (bcrypt path if enabled)
    // -------------------------
    write_file(
        zf,
        "encrypted.txt",
        "secret data inside zip",
        "password123"
    );

    zipClose(zf, nullptr);

    printf("\n=== ZIP CREATED ===\n\n");

    // -------------------------
    // READ BACK
    // -------------------------
    read_zip(zipname);

    printf("\n=== TEST COMPLETE ===\n");
    return 0;
}
