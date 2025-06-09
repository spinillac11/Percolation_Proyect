#include "declarations.h"


/*
Fill the laticce given the fill probability p
*/
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

/*
Save in a .txt the lattice
0 = full
1 = open
*/
void print(const Vec & lattice)
{
    int L = sqrt(lattice.size());
    // Open file
    std::ofstream outfile;
    outfile.open(filename);
    if (!outfile) throw std::runtime_error("No se pudo abrir " + filename);

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

/*
* UnionFind algorithm implementation
*/
int Find(Vec & parent, int ii)
{
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

int Union(Vec & parent, int ii, int jj)
{
    int parent_ii = Find(parent, ii);
    int parent_jj = Find(parent, jj);
    int min = std::min(parent_ii, parent_jj);
    int max = std::max(parent_ii, parent_jj);
    parent[max] = min;
    return min;
}

/*
* Hoshen-Kopelman algorithm implementation
*/
Vec HoshenKopelman(Vec & lattice)
{
    int L = sqrt(lattice.size());
    Vec labels(1, 0);
    int next_label = 1;
    int label_left;
    int label_up;

    for (int ii = 0; ii < L; ii++){
        for (int jj = 0; jj < L; jj++){

            int idx = ii*L + jj; // Index
            
            if (lattice[idx] == 0) continue;
            // Check if top or left side
            label_left = (jj > 0) ? lattice[idx - 1] : 0;
            label_up = (ii > 0) ? lattice[idx - L] : 0;
            
            if(label_left==0 && label_up==0){
                // new cluster
                labels.push_back(next_label);
                lattice[idx] = next_label++;
            }
            else if(label_left>0 && label_up==0){
                lattice[idx] = label_left;
            }
            else if(label_left==0 && label_up>0){
                lattice[idx] = label_up;
            }
            else
            {
                lattice[idx] = Union(labels, label_up, label_left);
            }
        }
    }

    return labels;
}

Map find_clusters(Vec & lattice)
{
    Vec labels = HoshenKopelman(lattice);
    Map size;

    // Join and sort clusters
    for(auto & i : lattice){
        if(i > 0){
            i = Find(labels, i);
        }
    }

    std::set<int> unique_ids(labels.begin(), labels.end());

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

    return size;
}

Vec detec_perc(const Vec & lattice) {

    int L = sqrt(lattice.size());
    std::set<int> top_row, bottom_row, left_col, right_col, percolantes;
 
    // Vertical
    for (int x = 0; x < L; ++x) {
        if (lattice[x] > 0)              top_row.insert(lattice[x]);
        if (lattice[(L - 1) * L + x] > 0) bottom_row.insert(lattice[(L - 1) * L + x]);
    }

    // Horizontal
    for (int y = 0; y < L; ++y) {
        if (lattice[y * L] > 0)              left_col.insert(lattice[y * L]);
        if (lattice[y * L + (L - 1)] > 0)    right_col.insert(lattice[y * L + (L - 1)]);
    }

    // Comparar etiquetas comunes entre bordes
    for (int label : top_row) {
        if (bottom_row.count(label)) {
            percolantes.insert(label);
        }
    }
    for (int label : left_col) {
        if (right_col.count(label)) {
            percolantes.insert(label);
        }
    }

    // Si no hay percolantes, retornar {0}
    if (percolantes.empty()) return {0}; 

    // Convertir set a vector
    return Vec(percolantes.begin(), percolantes.end());
}


