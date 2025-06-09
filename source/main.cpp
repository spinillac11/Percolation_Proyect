#include "declarations.h"

int main(int argc, char **argv) {
    // read parameters
    const int L = std::atoi(argv[1]);
    const double P = std::atof(argv[2]); 

    // Generate Lattice
    Vec Lattice(L*L, 0);
    
    // Generate map for cluster size
    Map cluster_size;   

    // Fill Lattice 
    fill_lattice(Lattice, P);

    // Print Lattice in console  
    print(Lattice, "lattice_plain.txt");

    // Find clusters 
    cluster_size = find_clusters(Lattice); 

    // Print Lattice with clusters
    print(Lattice, "lattice_clusters.txt"); 

    // Print each cluster size
    std::cout << "Cluster size:" << std::endl;
    for (const auto & [cluster, size] : cluster_size) {
        std::cout << cluster << "\t" << size << std::endl; 
    }

    Vec percol = detec_perc(Lattice);

    std::cout << "The Clusters that percolate are:" << std::endl;
    for (size_t i = 0; i < percol.size(); i++) {
        std::cout << percol[i] << std::endl;
    } 

    return 0;
}