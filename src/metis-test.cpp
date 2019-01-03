/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * taken from: https://gist.github.com/erikzenker/c4dc42c8d5a8c1cd3e5a
 */


#include <cstddef> /* NULL */
#include <metis.h>
#include <iostream>


// Install metis from:
// http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz

// Build with
// g++ metis.cc -lmetis

int main(){

    idx_t nVertices = 6;
    idx_t nEdges    = 7;
    idx_t nWeights  = 1;
    idx_t nParts    = 2;

    idx_t objval;
    idx_t part[nVertices];


    // Indexes of starting points in adjacent array
    idx_t xadj[nVertices+1] = {0,2,5,7,9,12,14};

    // Adjacent vertices in consecutive index order
    idx_t adjncy[2 * nEdges] = {1,3,0,4,2,1,5,0,4,3,1,5,4,2};

    // Weights of vertices
    // if all weights are equal then can be set to NULL
    idx_t vwgt[nVertices * nWeights];


    // int ret = METIS_PartGraphRecursive(&nVertices,& nWeights, xadj, adjncy,
    //                     NULL, NULL, NULL, &nParts, NULL,
    //                     NULL, NULL, &objval, part);

    int ret = METIS_PartGraphKway(&nVertices,& nWeights, xadj, adjncy,
                       NULL, NULL, NULL, &nParts, NULL,
                       NULL, NULL, &objval, part);

    std::cout << ret << std::endl;

    for(unsigned part_i = 0; part_i < nVertices; part_i++){
    std::cout << part_i << " " << part[part_i] << std::endl;
    }


    return 0;
}
