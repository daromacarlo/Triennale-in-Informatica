#include "supplier.h"
#include "utils.h"
#include "network.h"

Supplier::Supplier(int id, DB* db_ref) : id(id), db(db_ref) {}

void Supplier::doTransition() {
    int i = std::uniform_int_distribution<int>(1, PARAMS.P)(RNG); // [cite: 56]
    int q = std::uniform_int_distribution<int>(1, PARAMS.Q)(RNG); // [cite: 57]
    
    NET.schedule(PARAMS.r, [this, i, q]() {
        db->receiveFromSupplier(i, q);
        // Riceve ack (tempo r) [cite: 61, 64]
        NET.schedule(PARAMS.r, [this]() {
            double wait_time = std::uniform_real_distribution<double>(PARAMS.V, PARAMS.W)(RNG);
            NET.schedule(wait_time, [this]() { this->doTransition(); }); // [cite: 54, 55]
        });
    });
}