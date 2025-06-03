#include "UnionFind.h"
#include <algorithm> 

// Constructor
UnionFind::UnionFind(int max_labels){
    parent = Vec(max_labels, 0);
    next_label = 1;
}

int UnionFind::findSet(int ii){
    int jj = ii;
    int kk;
    while (parent[jj] != jj){
        jj = parent[jj];
    }
    while (parent[ii] != ii){
        kk = parent[ii];
        parent[ii] = jj;
        ii = kk;
    }
    return jj;
}

int UnionFind::unionSet(int ii, int jj){
    int parent_ii = findSet(ii);
    int parent_jj = findSet(jj);
    int min = std::min(parent_ii, parent_jj);
    int max = std::max(parent_ii, parent_jj);
    parent[max] = min;
    return min;
}

int UnionFind::createSet(){
    parent[next_label] = next_label;
    return next_label++;
}

