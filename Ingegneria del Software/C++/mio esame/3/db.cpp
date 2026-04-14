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
    table[i].q += q; // Incrementa q items [cite: 61]
}

std::tuple<int, int, int> DB::receiveFromServer(int i, int q) {
    int g = table[i].q;
    int k = std::min(q, g); // k = min(q, g) [cite: 36]
    table[i].q -= k;        // decrementa di k [cite: 37]
    return {i, k, table[i].v};
}