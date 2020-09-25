/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 */

#include "draco/compression/encode.h"
#include "draco/core/encoder_buffer.h"
#include "draco/core/status.h"
#include "draco/mesh/mesh.h"
#include "draco/mesh/triangle_soup_mesh_builder.h"
#include <iostream>

int main()
{
    // Generate a simple triangle mesh
    const int numFaces = 1;
    draco::TriangleSoupMeshBuilder meshBuilder;
    meshBuilder.Start(numFaces);

    // Create position attribute
    const int positionAttribute = meshBuilder.AddAttribute(
        draco::GeometryAttribute::POSITION, 3, draco::DT_FLOAT32);

    // Generate vertices and faces
    const int faceIndex = 0;
    meshBuilder.SetAttributeValuesForFace(
        positionAttribute, draco::FaceIndex(faceIndex),
        draco::Vector3f(-1, -1, 0).data(),
        draco::Vector3f(1, -1, 0).data(),
        draco::Vector3f(1, 1, 0).data());

    const std::unique_ptr<draco::Mesh> mesh = meshBuilder.Finalize();

    // Encode to buffer
    draco::Encoder encoder;
    draco::EncoderBuffer buffer;
    draco::Status status = encoder.EncodeMeshToBuffer(*mesh.get(), &buffer);
    if (!status.ok())
    {
        std::cerr << "Failed to encode mesh. Error = " << status.error_msg() << std::endl;
        return 1;
    }
    std::cout << "Successfully encoded mesh." << std::endl;
    return 0;
}
