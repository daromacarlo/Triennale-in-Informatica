#include <iostream>
#include <fstream>
#include <vector>
#include <numeric>
#include <random>
#include <cmath>
#include "utils.h"
#include "network.h"
#include "db.h"
#include "server.h"
#include "customer.h"
#include "supplier.h"

Params PARAMS;
std::mt19937 RNG;

// Funzione per testare una specifica combinazione di parametri M volte
double evaluate_simulation(double sep, double sop, double qea, double qoa) {
    PARAMS.SEP = sep;
    PARAMS.SOP = sop;
    PARAMS.QEA = qea;
    PARAMS.QOA = qoa;
    
    double total_reward_rate = 0.0;

    for (int m = 0; m < PARAMS.M; ++m) {
        NET.reset();
        DB db;
        db.init();

        std::vector<Server> servers;
        for (int i = 1; i <= PARAMS.S; ++i) servers.emplace_back(i, &db);

        std::vector<Customer> customers;
        for (int i = 1; i <= PARAMS.C; ++i) customers.emplace_back(i, servers);

        std::vector<Supplier> suppliers;
        for (int i = 1; i <= PARAMS.F; ++i) suppliers.emplace_back(i, &db);

        for (auto& s : servers) {
            int server_id = &s - &servers[0] + 1;
            double first_tau = (server_id % 2 == 0) ? PARAMS.ST0 : PARAMS.ST1;
            
            NET.schedule(first_tau, [&s]() { s.triggerCacheUpdate(); });
            NET.schedule(PARAMS.T, [&s]() { s.updateCostPeriodic(); });
        }

        for (auto& c : customers) {
            double first_transition = std::uniform_real_distribution<double>(PARAMS.A, std::max(PARAMS.A, PARAMS.B))(RNG);
            NET.schedule(first_transition, [&c]() { c.doTransition(); });
        }

        for (auto& sup : suppliers) {
            double first_transition = std::uniform_real_distribution<double>(PARAMS.V, std::max(PARAMS.V, PARAMS.W))(RNG);
            NET.schedule(first_transition, [&sup]() { sup.doTransition(); });
        }

        NET.run(PARAMS.H);

        double current_rr = 0.0;
        for (auto& s : servers) {
            current_rr += s.getRewardRate() / PARAMS.H; 
        }
        total_reward_rate += current_rr;
    }

    return total_reward_rate / PARAMS.M;
}

int main() {
    PARAMS.load("parameters.txt");
    std::random_device rd;
    RNG.seed(rd());

    double max_rr = -1e18; 
    
    struct ResultTuple { double sep, sop, qea, qoa, rr; };
    std::vector<ResultTuple> best_results;

    // Grid search su tutte le (G+1)^4 combinazioni
    for (int k1 = 0; k1 <= PARAMS.G; ++k1) {
        for (int k2 = 0; k2 <= PARAMS.G; ++k2) {
            for (int k3 = 0; k3 <= PARAMS.G; ++k3) {
                for (int k4 = 0; k4 <= PARAMS.G; ++k4) {
                    
                    double current_sep = (double)k1 / PARAMS.G;
                    double current_sop = (double)k2 / PARAMS.G;
                    double current_qea = (double)k3 / PARAMS.G;
                    double current_qoa = (double)k4 / PARAMS.G;
                    
                    double current_rr = evaluate_simulation(current_sep, current_sop, current_qea, current_qoa);
                    
                    // Verifica dell'ottimalità con tolleranza per float
                    if (current_rr > max_rr + 1e-9) {
                        max_rr = current_rr;
                        best_results.clear();
                        best_results.push_back({current_sep, current_sop, current_qea, current_qoa, current_rr});
                    } else if (std::abs(current_rr - max_rr) <= 1e-9) {
                        best_results.push_back({current_sep, current_sop, current_qea, current_qoa, current_rr});
                    }
                }
            }
        }
    }

    // Seleziona una configurazione ottima uniformemente a random
    std::uniform_int_distribution<size_t> dist(0, best_results.size() - 1);
    ResultTuple optimal = best_results[dist(RNG)];

    // Stampa output formattato come da istruzioni
    std::ofstream out("results.txt");
    out << "2026-04-10-Carlo-DaRoma-2086036\n"; 
    out << "RR " << optimal.rr << "\n";
    out << "SEP " << optimal.sep << "\n";
    out << "SOP " << optimal.sop << "\n";
    out << "QEA " << optimal.qea << "\n";
    out << "QOA " << optimal.qoa << "\n";

    return 0;
}