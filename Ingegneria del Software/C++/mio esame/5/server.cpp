#include "server.h"
#include "utils.h"
#include "network.h"
Server::Server(int id, DB* db_ref) : id(id), db(db_ref) {
    cache.resize(PARAMS.P + 1); sellBuy = 0.0; y = 0.0;
}
void Server::updateCostPeriodic() {
    double current_cost = 0;
    for (int i = 1; i <= PARAMS.P; ++i) current_cost += cache[i].q * cache[i].v; 
    y += PARAMS.T * 0.1 * current_cost; 
    NET.schedule(PARAMS.T, [this]() { this->updateCostPeriodic(); });
}
void Server::handleCustomerRequest(int /*customer_id*/, int i, int q) {
    int g = cache[i].q; int k = std::min(q, g);
    cache[i].q -= k; sellBuy += k * cache[i].v; 
}
void Server::triggerCacheUpdate() {
    bool isEven = (id % 2 == 0);
    double prob_i = isEven ? PARAMS.SEP : PARAMS.SOP; 
    double prob_q = isEven ? PARAMS.QEA : PARAMS.QOA; 
    std::uniform_real_distribution<double> dist01(0.0, 1.0);
    
    int i_req = 1; bool req_even_i = dist01(RNG) < prob_i;
    std::vector<int> i_candidates;
    for(int i=1; i<=PARAMS.P; i++) if((i%2==0) == req_even_i) i_candidates.push_back(i);
    if(!i_candidates.empty()) i_req = i_candidates[std::uniform_int_distribution<int>(0, i_candidates.size()-1)(RNG)];

    int q_req = 1; bool req_even_q = dist01(RNG) < prob_q;
    std::vector<int> q_candidates;
    for(int q=1; q<=PARAMS.Q; q++) if((q%2==0) == req_even_q) q_candidates.push_back(q);
    if(!q_candidates.empty()) q_req = q_candidates[std::uniform_int_distribution<int>(0, q_candidates.size()-1)(RNG)];

    NET.schedule(PARAMS.r, [this, i_req, q_req]() {
        auto [i_res, k_res, v_res] = db->receiveFromServer(i_req, q_req);
        NET.schedule(PARAMS.r, [this, i_res, k_res, v_res]() {
            this->handleDBReply(i_res, k_res, v_res);
        });
    });
    double next_tau = isEven ? PARAMS.ST0 : PARAMS.ST1;
    NET.schedule(next_tau, [this]() { this->triggerCacheUpdate(); });
}
void Server::handleDBReply(int i, int k, int v) {
    cache[i].q += k; cache[i].v = v; sellBuy -= k * v; 
}