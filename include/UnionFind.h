#pragma once

#include "vec_maps.h"

struct UnionFind
{
    // Declaration of variables
    Vec parent;
    int next_label;

    // Contructor
    UnionFind(int max_labels);

    // Methods
    int findSet(int ii);
    int unionSet(int ii, int jj);
    int createSet();
};