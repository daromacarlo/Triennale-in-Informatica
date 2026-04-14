#pragma once
#include "server.h"
#include <vector>

class Customer {
    int id;
    std::vector<Server>& servers;
public:
    Customer(int id, std::vector<Server>& servers_ref);
    void doTransition();
};