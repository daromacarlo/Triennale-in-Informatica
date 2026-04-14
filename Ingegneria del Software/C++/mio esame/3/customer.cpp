#include "customer.h"
#include "utils.h"
#include "network.h"

Customer::Customer(int id, std::vector<Server>& servers_ref) : id(id), servers(servers_ref) {}

void Customer::doTransition() {
    std::uniform_real_distribution<double> dist01(0.0, 1.0);
    
    // 1. Scelta Server s [cite: 14, 15]
    double s0_actual = (PARAMS.S == 1) ? 0.0 : PARAMS.S0; // Fix per S=1 [cite: 22]
    bool even_s = dist01(RNG) < s0_actual;
    std::vector<int> s_candidates;
    for(int s=1; s<=PARAMS.S; s++) if((s%2==0) == even_s) s_candidates.push_back(s);
    int s = s_candidates[std::uniform_int_distribution<int>(0, s_candidates.size()-1)(RNG)];

    // 2. Scelta prodotto i [cite: 16, 17]
    bool even_p = dist01(RNG) < PARAMS.P0;
    std::vector<int> p_candidates;
    for(int i=1; i<=PARAMS.P; i++) if((i%2==0) == even_p) p_candidates.push_back(i);
    int i_prod = p_candidates[std::uniform_int_distribution<int>(0, p_candidates.size()-1)(RNG)];

    // 3. Scelta quantità q [cite: 18, 19]
    bool even_q = dist01(RNG) < PARAMS.Q0;
    std::vector<int> q_candidates;
    for(int q=1; q<=PARAMS.Q; q++) if((q%2==0) == even_q) q_candidates.push_back(q);
    int q_req = q_candidates[std::uniform_int_distribution<int>(0, q_candidates.size()-1)(RNG)];

    // Invia a Server (tempo r)
    NET.schedule(PARAMS.r, [this, s, i_prod, q_req]() {
        servers[s-1].handleCustomerRequest(id, i_prod, q_req);
        // Attende risposta, poi torna allo stato 0
        NET.schedule(PARAMS.r, [this]() {
            double wait_time = std::uniform_real_distribution<double>(PARAMS.A, PARAMS.B)(RNG);
            NET.schedule(wait_time, [this]() { this->doTransition(); }); // [cite: 12, 13]
        });
    });
}