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

TEST_CASE("Hoshen-Kopelman, find_clusters and size test") {

    SECTION("Hoshen-Kopelman test"){
        // Todos conectados
        Vec lattice = {
        1, 1, 0, 0,
        0, 1, 0, 1,
        0, 1, 0, 1,
        0, 1, 1, 1
        };
        Vec cluster = {
        1, 1, 0, 0,
        0, 1, 0, 2,
        0, 1, 0, 2,
        0, 1, 1, 1
        };
        Vec labels;
        labels = HoshenKopelman(lattice);
        REQUIRE(labels.size() == 3);
        for(auto ii = 0; ii < 16; ii++){
            REQUIRE(lattice[ii] == cluster[ii]);
        }
    }

    SECTION("full lattice"){
        Vec full = {
            1,1,
            1,1
        };
        Map clusters;
        clusters = find_clusters(full);
        REQUIRE(clusters.size() == 1);
        REQUIRE(clusters[1] == 4);
    }

    SECTION("One cluster"){
        Vec lattice = {
        1, 0,
        0, 0
        };
        Map clusters;

        // 
        clusters = find_clusters(lattice);
        REQUIRE(clusters.size() == 2);
        REQUIRE(clusters[0] == 3);
        REQUIRE(clusters[1] == 1);
    }
    
    SECTION("Max clusters"){
        Vec lattice = {
        1, 0, 1, 0,
        0, 1, 0, 1,
        1, 0, 1, 0,
        0, 1, 0, 1
        };
        Map clusters;

        // 
        clusters = find_clusters(lattice);
        REQUIRE(clusters.size() == 9);
        REQUIRE(clusters[0] == 8);
        REQUIRE(clusters[1] == 1);
        REQUIRE(clusters[2] == 1);
        REQUIRE(clusters[3] == 1);
        REQUIRE(clusters[4] == 1);
        REQUIRE(clusters[5] == 1);
        REQUIRE(clusters[6] == 1);
        REQUIRE(clusters[7] == 1);
        REQUIRE(clusters[8] == 1);
    }
}

TEST_CASE("detect_perc function test"){

    SECTION("No percolation") {
        
        Vec lattice2(4, 0);
        Vec per2 = detec_perc(lattice2);
        REQUIRE(per2 == Vec{0});

        Vec lattice3(9,0);
        Vec per3 = detec_perc(lattice3);
        REQUIRE(per3 == Vec{0});

        Vec lattice = {
            1,1,0,  
            0,1,2,  
            0,2,2  
        };
        Vec per = detec_perc(lattice);
        REQUIRE(per == Vec{0});
    }

    SECTION("vertical/horizontal percolation (2 clusters)") {
        Vec lattice1 = {
            1,0,2,
            1,0,2,
            1,0,2
        };
        Vec per1 = detec_perc(lattice1);
        REQUIRE(per1 == Vec{1, 2});

        Vec lattice2 = {
            1,1,1,
            0,0,0,
            2,2,2
        };
        Vec per2 = detec_perc(lattice2);
        REQUIRE(per2 == Vec{1, 2});
    }

    SECTION("vertical & horizontal percolation") {
        Vec lattice = {
            0,1,0,
            1,1,1,
            0,1,0
        };
        Vec per = detec_perc(lattice);
        REQUIRE(per == Vec{1});
    }
}