#include "declarations.h"

int main(int argc, char **argv) {
    //start chrono
    auto start = std::chrono::steady_clock::now();
    // read parameters
    const int L = std::atoi(argv[1]);
    const double P = std::atof(argv[2]); 

    // Generate Lattice
    Vec Lattice(L*L, 0);
    
    // Generate map for cluster size
    Map cluster_size;   

    // Fill Lattice 
    fill_lattice(Lattice, P);

    // Print Plain Lattice 
    print(Lattice, "lattice_plain.txt");

    // Find clusters 
    cluster_size = find_clusters(Lattice); 

    // Print Lattice with clusters
    print(Lattice, "lattice_clusters.txt"); 

    // Find clusters that percolate
    Vec percol = detec_perc(Lattice);

    // Print if percolates and max size
    if (percol.size() == 1 && percol[0] == 0){
        std::cout << L << "\t" << P << "\t" << 0 << "\t" << 0 << "\t" << 0 << "\t";
    }
    else{
        // Find biggest percolating cluster
        int max_id = percol[0];
        int max_size = cluster_size[max_id];

        for(int id : percol){
            int size = cluster_size[id];
            if(size > max_size){
                max_size = size; 
                max_id = id;
            }
        }

        std::cout << L << "\t" << P << "\t" << 1 << "\t" << max_id << "\t" << max_size << "\t";
    }

    //end chronometer
    auto end = std::chrono::steady_clock::now();
    //Calculate time
    auto elapse = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    std::cout << elapse << std::endl;

    return 0;
}