/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 */

#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

#include <iostream>

/// C++ example lifted from the assimp documentation.
int main() {
    /* NFF file for a single spere with radius 5 at pos 0x0x0 */
    std::string buf(
        "--- begin of file\n"
        "s 0 0 0 5\n"
        "--- end of file\n"
        );
  // Create an instance of the Importer class
  Assimp::Importer importer;

  // And have it read the given file with some example postprocessing
  // Usually - if speed is not the most important aspect for you - you'll
  // probably to request more postprocessing than we do in this example.
  const aiScene* scene = importer.ReadFile( buf,
    aiProcess_CalcTangentSpace       |
    aiProcess_Triangulate            |
    aiProcess_JoinIdenticalVertices  |
    aiProcess_SortByPType);

  // If the import failed, report it
  if (!scene) {
    std::cerr << importer.GetErrorString() << std::endl;
    return -1;
  }

  // Now we can access the file's contents.
  if (scene->mNumMeshes != 1) return -1;

  // We're done. Everything will be cleaned up by the importer destructor
  return 0;
}
