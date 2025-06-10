#define CATCH_CONFIG_MAIN  
#include "catch2/catch_test_macros.hpp"
#include "declarations.h"

TEST_CASE("fill_lattice function test"){
    const int N = 100;
    Vec Lattice(N, -1);

    SECTION("p = 0.0, all zeros"){
        fill_lattice(Lattice, 0.0);
        for (auto x : Lattice){
            REQUIRE(x == 0);
        }
    }
    SECTION("p = 1.0, all ones"){
        fill_lattice(Lattice, 1.0);
        for (auto x : Lattice){
            REQUIRE(x == 1);
        }
    }
    SECTION("p = 0.5 approx 50%"){
        fill_lattice(Lattice, 0.5);
        int sum = std::accumulate(Lattice.begin(), Lattice.end(), 0);
        double frac = double(sum) / N;
        REQUIRE(frac >= 0.4);
        REQUIRE(frac <= 0.6);
    }
    SECTION("p > 1, all ones"){
        fill_lattice(Lattice, 10.5);
        for (auto x : Lattice){
            REQUIRE(x == 1);
        }
    }
    SECTION("p < 1, all zeros"){
        fill_lattice(Lattice, -0.5);
        for (auto x : Lattice){
            REQUIRE(x == 0);
        }
    }
}

TEST_CASE("Union-Find algorithm and path compresion test") {

    SECTION("Find root and path compresion:"){
        Vec parent = {0,0,1,2,3,4};
        // Find should return 0
        int root = Find(parent, 5);
        REQUIRE(root == 0);
        // Afeter compresion, all idxs should poit to 0
        for(auto x : parent){
            REQUIRE(parent[x] == 0);
        }
    }  
    SECTION("Two root union"){
        Vec parent = {0,1};
        // Minor root
        int r = Union(parent, 0, 1);
        REQUIRE(r==0); 
        // Idempotence
        int r2 = Union(parent, 0, 1);
        REQUIRE(r2 == r);
    }
}

TEST_CASE("Hoshen-Kopelman and find_clusters test") {
    Vec lattice = {
        1, 0,
        0, 0
    };
    Map clusters;

    // find_clusters etiqueta el único 1 como cluster 0 de tamaño 1
    clusters = find_clusters(lattice);
    REQUIRE(clusters.size() == 2);
    REQUIRE(clusters[0] == 3);
    REQUIRE(clusters[1] == 1);
    

    // Todos conectados
    Vec full = {
        1,1,
        1,1
    };
    clusters = find_clusters(full);
    REQUIRE(clusters.size() == 1);
    REQUIRE(clusters[1] == 4);
}