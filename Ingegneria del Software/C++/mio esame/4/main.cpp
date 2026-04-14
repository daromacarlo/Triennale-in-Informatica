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

// Funzione isolata che valuta la simulazione M volte per una coppia data
double evaluate_simulation(double st0, double st1) {
    PARAMS.ST0 = st0;
    PARAMS.ST1 = st1;
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

    double step = (PARAMS.b - PARAMS.a) / PARAMS.G; // Discretizzazione [cite: 142]
    double max_rr = -1e18; 
    
    struct ResultPair { double st0, st1, rr; };
    std::vector<ResultPair> best_results;

    // Grid search su tutte le (G+1)^2 combinazioni
    for (int k0 = 0; k0 <= PARAMS.G; ++k0) {
        for (int k1 = 0; k1 <= PARAMS.G; ++k1) {
            double current_st0 = PARAMS.a + k0 * step;
            double current_st1 = PARAMS.a + k1 * step;
            
            double current_rr = evaluate_simulation(current_st0, current_st1);
            
            // Logica per individuare i massimi (con tolleranza per i float)
            if (current_rr > max_rr + 1e-9) {
                max_rr = current_rr;
                best_results.clear();
                best_results.push_back({current_st0, current_st1, current_rr});
            } else if (std::abs(current_rr - max_rr) <= 1e-9) {
                best_results.push_back({current_st0, current_st1, current_rr});
            }
        }
    }

    // Seleziona un risultato ottimo uniformemente a random in caso di pareggio 
    std::uniform_int_distribution<size_t> dist(0, best_results.size() - 1);
    ResultPair optimal = best_results[dist(RNG)];

    // Stampa output formattato
    std::ofstream out("results.txt");
    
    // ATTENZIONE: SOSTITUISCI QUESTA RIGA CON LA TUA ROOT DIRECTORY CORRETTA [cite: 242]
    out << "2026-04-10-Carlo-DaRoma-2086036\n"; 
    
    out << "RR " << optimal.rr << "\n";
    out << "ST0 " << optimal.st0 << "\n";
    out << "ST1 " << optimal.st1 << "\n";

    return 0;
}