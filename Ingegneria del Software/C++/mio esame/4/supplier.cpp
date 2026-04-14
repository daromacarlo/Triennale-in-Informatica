#include "supplier.h"
#include "utils.h"
#include "network.h"
#include <algorithm>

Supplier::Supplier(int id, DB* db_ref) : id(id), db(db_ref) {}

void Supplier::doTransition() {
    int p_max = std::max(1, PARAMS.P);
    int q_max = std::max(1, PARAMS.Q);
    int i = std::uniform_int_distribution<int>(1, p_max)(RNG); 
    int q = std::uniform_int_distribution<int>(1, q_max)(RNG); 
    
    NET.schedule(PARAMS.r, [this, i, q]() {
        db->receiveFromSupplier(i, q);
        NET.schedule(PARAMS.r, [this]() {
            double wait_time = std::uniform_real_distribution<double>(PARAMS.V, std::max(PARAMS.V, PARAMS.W))(RNG);
            NET.schedule(wait_time, [this]() { this->doTransition(); }); 
        });
    });
}