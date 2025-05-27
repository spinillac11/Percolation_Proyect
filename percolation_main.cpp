#include <iostream>
#include <ctime>
#include <random>
#include <cmath>
#include <cstdlib>
#include <vector>
#include <fstream>

typedef std::vector<int> Vec;

void fill_laticce(Vec & lattice, double p, int seed);
void print(Vec & lattice);



int main(int argc, char **argv) {
    // read parameters
    const int L = std::atoi(argv[1]);
    const double P = std::atof(argv[2]); 
    // const int SEED = std::atoi(argv[3]);
    std::random_device SEED;

    // Generate Lattice
    Vec Lattice(L*L, 0);  

    // Fill Lattice 
    fill_laticce(Lattice, P, SEED());    

    // Print Lattice 
    print(Lattice); 

    return 0;
}

void fill_laticce(Vec & lattice, double p, int seed){

    int size = lattice.size();

    std::mt19937 gen(seed);
    std::bernoulli_distribution dist(p);  

    for (int i = 0; i < size ; ++i) {
        bool fill = dist(gen);
        lattice[i] = fill ? 1 : 0;  // 0 = lleno, 1 = abierto
    }
}

void print(Vec & lattice){
    int L = sqrt(lattice.size());
    // Open file
    std::ofstream outfile;
    outfile.open("lattice.txt");

    for (int ii = 0; ii < L; ii++) {
        for (int jj = 0; jj < L; jj++) {
            outfile << lattice[ii * L + jj] << ' ';
        }
        outfile << '\n';
    }
    outfile.close();
}