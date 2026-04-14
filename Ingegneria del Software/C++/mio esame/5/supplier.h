#pragma once
#include "db.h"
class Supplier {
    int id; DB* db;
public:
    Supplier(int id, DB* db_ref);
    void doTransition();
};