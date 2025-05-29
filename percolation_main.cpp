#include <iostream>
#include <ctime>
#include <random>
#include <cmath>
#include <cstdlib>
#include <vector>
#include <fstream>
#include <set>
#include <map>

typedef std::vector<int> Vec;

struct UnionFind {
    Vec parent;
    int next_label;

    //Consturctor
    UnionFind(int max_labels){
        parent = Vec(max_labels, 0);
        next_label = 1;
    }

    int Find(int ii){
        int jj = ii;
        int kk;
        while (parent[jj] != jj)
        {
            jj = parent[jj];
        }
        while (parent[ii] != ii)
        {
            kk = parent[ii];
            parent[ii] = jj;
            ii = kk;
        }
        return jj;
    }

    int Union(int ii, int jj){
        int parent_ii = Find(ii);
        int parent_jj = Find(jj);
        int min = std::min(parent_ii, parent_jj);
        int max = std::max(parent_ii, parent_jj);
        parent[max] = min;
        return min;
    }

    int create_set(){
        parent[next_label] = next_label;
        return next_label++;
    }

    void sort_ids(){
        std::set<int> unique_ids(parent.begin(), parent.end());

        std::map<int, int> sort;
        int next_id = 0;
        for(auto & x : unique_ids){
            sort[x] = next_id;
            next_id++;
        }

        for(auto & x : parent){
            x = sort[x];
        }
    }
};

void fill_laticce(Vec & lattice, double p);
void print(Vec & lattice);
void find_clusters(Vec & lattice);



int main(int argc, char **argv) {
    // read parameters
    const int L = std::atoi(argv[1]);
    const double P = std::atof(argv[2]); 
    // const int SEED = std::atoi(argv[3]);
    

    // Generate Lattice
    Vec Lattice(L*L, 0);  

    // Fill Lattice 
    fill_laticce(Lattice, P);  
    for (int y = 0; y < L; ++y) {
        for (int x = 0; x < L; ++x) {
            std::cout << Lattice[y * L + x] << ' ';
        }
        std::cout << '\n';
    } 
    std::cout << '\n';

    // Find clusters
    find_clusters(Lattice); 

    // Print Lattice 
    print(Lattice); 

    return 0;
}

void fill_laticce(Vec & lattice, double p)
{
    int size = lattice.size();

    std::random_device SEED;
    std::mt19937 gen(SEED());
    std::bernoulli_distribution dist(p);  

    for (int i = 0; i < size ; ++i) 
    {
        bool fill = dist(gen);
        lattice[i] = fill ? 1 : 0;  // 0 = lleno, 1 = abierto
    }
}

void print(Vec & lattice)
{
    int L = sqrt(lattice.size());
    // Open file
    std::ofstream outfile;
    outfile.open("lattice.txt");

    for (int ii = 0; ii < L; ii++) 
    {
        for (int jj = 0; jj < L; jj++) 
        {
            outfile << lattice[ii*L + jj] << ' ';
        }
        outfile << '\n';
    }
    outfile.close();
}

void find_clusters(Vec & lattice)
{
    int L = sqrt(lattice.size());
    UnionFind labels(int(L*L/2));

    int label_left;
    int label_up;

    for (int ii = 0; ii < L; ii++) 
    {
        for (int jj = 0; jj < L; jj++) 
        {
            int idx = ii*L + jj; // Index
            
            if (lattice[ii*L + jj] == 0) continue;

            label_left = (jj > 0) ? lattice[idx - 1] : 0;
            label_up = (ii > 0) ? lattice[idx - L] : 0;
            
            if(label_left==0 && label_up==0){
                // nuevo clúster
                lattice[idx] = labels.create_set();
            }
            else if(label_left>0 && label_up==0){
                lattice[idx] = label_left;
            }
            else if(label_left==0 && label_up>0){
                lattice[idx] = label_up;
            }
            else
            {
                lattice[idx] = labels.Union(label_up, label_left);
            }
        }
    }
    for (int y = 0; y < L; ++y) {
        for (int x = 0; x < L; ++x) {
            std::cout << lattice[y * L + x] << ' ';
        }
        std::cout << '\n';
    } 
    std::cout << '\n';

    // Join clusters
    for (int i = 0; i < L*L; i++)
    {
        if(lattice[i] > 0){
            lattice[i] = labels.Find(lattice[i]);
        }
    }

    for (int y = 0; y < L; ++y) {
        for (int x = 0; x < L; ++x) {
            std::cout << lattice[y * L + x] << ' ';
        }
        std::cout << '\n';
    } 
    std::cout << '\n';
}