#include "functions.h"
#include "UnionFind.h"
#include <random>
#include <fstream>
#include <set>


// Fill the laticce given the fill probability p
void fillLaticce(Vec & lattice, double p)
{
    int size = lattice.size();

    std::random_device SEED;
    std::mt19937 gen(SEED());
    std::bernoulli_distribution dist(p);  

    for (int i = 0; i < size ; ++i){
        bool fill = dist(gen);
        lattice[i] = fill ? 1 : 0;  // 0 = full, 1 = open
    }
}

// Save in a .txt the lattice
// 0 = full
// 1 = open
void saveLattice(Vec & lattice)
{
    int L = sqrt(lattice.size());

    // Open file
    std::ofstream outfile;
    outfile.open("lattice_mod.txt");

    for (int ii = 0; ii < L; ii++) 
    {
        for (int jj = 0; jj < L; jj++) 
        {
            outfile << lattice[ii*L + jj] << ' ';
        }
        outfile << '\n';
    }
    // Close file
    outfile.close();
}

// 
void findClusters(Vec & lattice,  Map & size)
{
    int L = sqrt(lattice.size());
    UnionFind labels(int(L*L/2));

    int label_left, label_up;

    for (int ii = 0; ii < L; ii++) 
    {
        for (int jj = 0; jj < L; jj++) 
        {
            int idx = ii*L + jj; // Index
            
            if (lattice[idx] == 0) continue;

            label_left = (jj > 0) ? lattice[idx - 1] : 0;
            label_up = (ii > 0) ? lattice[idx - L] : 0;
            
            if(label_left==0 && label_up==0){
                // nuevo clúster
                lattice[idx] = labels.createSet();
            }
            else if(label_left>0 && label_up==0){
                lattice[idx] = label_left;
            }
            else if(label_left==0 && label_up>0){
                lattice[idx] = label_up;
            }
            else
            {
                lattice[idx] = labels.unionSet(label_up, label_left);
            }
        }
    }

    // Join and sort clusters
    for(auto & i : lattice){
        if(i > 0){
            i = labels.findSet(i);
        }
    }

    std::set<int> unique_ids(lattice.begin(), lattice.end());

    Map sort;
    int next_id = 0;
    for(auto & x : unique_ids){
        sort[x] = next_id;
        next_id++;
    }

    for(auto & x : lattice){
        x = sort[x];
        size[x]++; // Count cluster size
    }
}