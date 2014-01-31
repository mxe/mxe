/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <assimp/cimport.h>
#include <assimp/scene.h>
#include <assimp/postprocess.h>
#include <string.h>

int main(int argc, char *argv[])
{
    const struct aiScene* scene = NULL;

    /* NFF file for a single spere with radius 5 at pos 0x0x0 */
    const char* buf =
        "--- begin of file\n"
        "s 0 0 0 5\n"
        "--- end of file\n";

    (void)argc;
    (void)argv;

    scene = aiImportFileFromMemory(buf, strlen(buf), aiProcessPreset_TargetRealtime_MaxQuality, "nff");
    (void)scene;

    if (scene->mNumMeshes != 1) return 1;

    aiReleaseImport(scene);
    return 0;
}
