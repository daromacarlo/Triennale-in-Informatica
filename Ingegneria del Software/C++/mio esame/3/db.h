#pragma once
#include <vector>
#include <tuple>

class DB {
    struct Item { int q; int v; };
    std::vector<Item> table;
public:
    void init();
    void receiveFromSupplier(int i, int q);
    std::tuple<int, int, int> receiveFromServer(int i, int q); // ritorna (i, k, v)
};