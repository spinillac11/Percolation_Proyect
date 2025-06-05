#define CATCH_CONFIG_MAIN  
#include "catch2/catch_test_macros.hpp"
#include "declarations.h"

TEST_CASE("Fill lattice function test"){
    Vec Lattice{0, 0, 0 ,0,
                0, 0, 0, 0,
                0, 0, 0 ,0,
                0, 0, 0, 0};

    double p0 = 0.0;
    double p1 = 1.0;
    fill_laticce(Lattice, p0);
    for(auto x : Lattice){
        REQUIRE(Lattice[x] == 0);
    }
    fill_laticce(Lattice, p1);
    for(auto x : Lattice){
        REQUIRE(Lattice[x] == 1);
    }
}