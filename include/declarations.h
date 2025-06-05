#pragma once
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
typedef std::map<int,int> Map;


void fill_laticce(Vec & lattice, double p);
void print(const Vec & lattice);
int Find(Vec & parent, int ii);
int Union(Vec & parent, int ii, int jj);
Vec HoshenKopelman(Vec & lattice);
Map find_clusters(Vec & lattice);
Vec detec_perc(const Vec & lattice);
