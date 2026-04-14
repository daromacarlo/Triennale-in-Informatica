#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cmath>
#include <iomanip>
#include "Drone.h"

using namespace std;

int main() {
  
    double T, H, L, V, a, b, D = 1.0; // D default se non fornito
    int N, M;

  
    ifstream pFile("parameters.txt");
    string id;
    while (pFile >> id) {
        if (id == "T") pFile >> T;
        else if (id == "H") pFile >> H;
        else if (id == "M") pFile >> M;
        else if (id == "N") pFile >> N;
        else if (id == "L") pFile >> L;
        else if (id == "V") pFile >> V;
        else if (id == "a") pFile >> a;
        else if (id == "b") pFile >> b;
        else if (id == "D") pFile >> D; 
    }
    pFile.close();

    double sumCollisionRates = 0;

    
    for (int m = 0; m < M; ++m) {
        vector<Drone> drones;
        for (int i = 0; i < N; ++i) {
            drones.emplace_back(L, V, T, a, b);
        }

        long totalCollisions = 0;

        for (double t = 0; t <= H; t += T) {

            for (int i = 0; i < N; ++i) {
                for (int j = i + 1; j < N; ++j) {
                    double dx = drones[i].getX() - drones[j].getX();
                    double dy = drones[i].getY() - drones[j].getY();
                    double dz = drones[i].getZ() - drones[j].getZ();
                    if (std::sqrt(dx*dx + dy*dy + dz*dz) < D) {
                        totalCollisions++;
                    }
                }
            }
            // Aggiornamento posizioni per prossimo step
            for (auto& drone : drones) drone.updateState();
        }
        sumCollisionRates += (double)totalCollisions / H; // 
    }


    ofstream rFile("results.txt");
    rFile << "2026-04-10-Carlo-DaRoma-2086036" << endl; 
    rFile << "C " << fixed << setprecision(2) << (sumCollisionRates / M) << endl;
    rFile.close();

    return 0;
}