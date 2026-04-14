#include <iostream>
#include <fstream>
#include <vector>
#include <numeric>
#include <random>
#include "utils.h"
#include "network.h"
#include "db.h"
#include "server.h"
#include "customer.h"
#include "supplier.h"

// Variabili globali dichiarate in utils.h
Params PARAMS;
std::mt19937 RNG;

int main() {
    // 1. Caricamento dei parametri dal file
    PARAMS.load("parameters.txt");

    // 2. Inizializzazione del generatore di numeri casuali
    std::random_device rd;
    RNG.seed(rd());

    double total_reward_rate = 0.0;

    // 3. Ciclo principale per le M Simulazioni Monte Carlo
    for (int m = 0; m < PARAMS.M; ++m) { 
        // Reset della rete e del tempo per la nuova simulazione
        NET.reset();

        DB db;
        db.init();

        std::vector<Server> servers;
        for (int i = 1; i <= PARAMS.S; ++i) {
            servers.emplace_back(i, &db);
        }

        std::vector<Customer> customers;
        for (int i = 1; i <= PARAMS.C; ++i) {
            customers.emplace_back(i, servers);
        }

        std::vector<Supplier> suppliers;
        for (int i = 1; i <= PARAMS.F; ++i) {
            suppliers.emplace_back(i, &db);
        }

        // --- Setup degli eventi iniziali ---

        // Servers: aggiornamento cache e calcolo periodico dei costi (parametro T)
        for (auto& s : servers) {
            int server_id = &s - &servers[0] + 1; // ID 1-based
            double first_tau = (server_id % 2 == 0) ? PARAMS.ST0 : PARAMS.ST1;
            
            NET.schedule(first_tau, [&s]() { s.triggerCacheUpdate(); });
            
            // Nuovo: Schedula il primo calcolo dei costi al tempo T
            NET.schedule(PARAMS.T, [&s]() { s.updateCostPeriodic(); });
        }

        // Customers: prima transizione dopo un tempo random in [A, B]
        for (auto& c : customers) {
            double first_transition = std::uniform_real_distribution<double>(PARAMS.A, PARAMS.B)(RNG);
            NET.schedule(first_transition, [&c]() { c.doTransition(); });
        }

        // Suppliers: prima transizione dopo un tempo random in [V, W]
        for (auto& sup : suppliers) {
            double first_transition = std::uniform_real_distribution<double>(PARAMS.V, PARAMS.W)(RNG);
            NET.schedule(first_transition, [&sup]() { sup.doTransition(); });
        }

        // --- Esecuzione ---
        // Avvia il gestore degli eventi fino all'orizzonte temporale H
        NET.run(PARAMS.H);

        // --- Calcolo dei Risultati ---
        // Calcola il Reward Rate al tempo H per la simulazione corrente
        double current_rr = 0.0;
        for (auto& s : servers) {
            // Formula (3): sum( (beta(s, H) - y(s, H)) / H )
            current_rr += s.getRewardRate() / PARAMS.H; 
        }
        total_reward_rate += current_rr;
    }

    // 4. Calcolo della media finale
    double expected_rr = total_reward_rate / PARAMS.M;

    // 5. Scrittura su file results.txt rispettando il formato richiesto
    std::ofstream out("results.txt");
    
    // ATTENZIONE: Questa riga DEVE coincidere esattamente con il nome della tua root directory.
    // Modificala con i tuoi dati reali in sede di esame.
    out << "2026-04-10-Carlo-DaRoma-2086036\n"; 
    out << "RR " << expected_rr << "\n";

    return 0;
}