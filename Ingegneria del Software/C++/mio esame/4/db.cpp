#include "db.h"
#include "utils.h"

void DB::init() {
    table.resize(PARAMS.P + 1);
    std::uniform_int_distribution<int> distQ(0, PARAMS.Q);
    std::uniform_int_distribution<int> distV(1, 100);
    for (int i = 1; i <= PARAMS.P; ++i) {
        table[i] = {distQ(RNG), distV(RNG)};
    }
}

void DB::receiveFromSupplier(int i, int q) {
    table[i].q += q; 
}

std::tuple<int, int, int> DB::receiveFromServer(int i, int q) {
    int g = table[i].q;
    int k = std::min(q, g); 
    table[i].q -= k;        
    return {i, k, table[i].v};
}