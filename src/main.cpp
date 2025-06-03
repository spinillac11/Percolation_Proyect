#include "functions.h"
#include "UnionFind.h"
#include "vec_maps.h"

#include <cstdlib>
#include <iostream>

int main (int argc, char **argv){
    
    // read parameters
    const int L = std::atoi(argv[1]); // Grid size
    const double p = std::atof(argv[2]); // Filling probability 0 \leq p \leq 1
    
    // Generate lattice
    Vec lattice (L*L, 0);

    // Generate map for cluster size
    Map clusterSize;

    // Fill lattice
    fillLaticce(lattice, p);

    // Print Lattice in console  
    for (int y = 0; y < L; ++y) {
        for (int x = 0; x < L; ++x) {
            std::cout << lattice[y * L + x] << ' ';
        }
        std::cout << '\n';
    } 
    std::cout << '\n';

    // Find clusters
    findClusters(lattice, clusterSize);

    // Save lattice in a .txt
    saveLattice(lattice);

    // Print each cluster size
    std::cout << "Cluster" << "\t" << "size:" << std::endl;
    for (const auto& [cluster, size] : clusterSize) {
        std::cout << cluster << "\t" << size << std::endl;
    }

    return 0;
}