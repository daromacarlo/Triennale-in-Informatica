#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cmath>
#include <iomanip>
#include <algorithm>
#include "Drone.h"

using namespace std;

/**

 */
void readParameters(double &T, double &H, double &L, double &V, int &N, int &M, double &a, double &b, double &r, double &D) {
    ifstream pFile("parameters.txt");
    if (!pFile.is_open()) {
        cerr << "Errore: impossibile aprire parameters.txt" << endl;
        exit(1);
    }

    string id;
    while (pFile >> id) {
        if (id == "T") pFile >> T;
        else if (id == "H") pFile >> H;
        else if (id == "L") pFile >> L;
        else if (id == "V") pFile >> V;
        else if (id == "N") pFile >> N;
        else if (id == "M") pFile >> M;
        else if (id == "a") pFile >> a;
        else if (id == "b") pFile >> b;
        else if (id == "r") pFile >> r; 
        else if (id == "D") pFile >> D; 
    }
    pFile.close();
}

int main() {

    double T, H, L, V, a, b, r, D = 1.0; 
    int N, M;

    readParameters(T, H, L, V, N, M, a, b, r, D);

    double sumCollisionRates = 0.0;

 
    for (int m = 0; m < M; ++m) {
        vector<Drone> drones;

        for (int i = 0; i < N; ++i) {
            drones.emplace_back(L, V, T, a, b);
        }

        long totalCollisionsCount = 0;

  
        for (double t = 0.0; t <= H; t += T) {
            

            for (int i = 0; i < N; ++i) {
                for (int j = i + 1; j < N; ++j) {
                    double dx = drones[i].getX() - drones[j].getX();
                    double dy = drones[i].getY() - drones[j].getY();
                    double dz = drones[i].getZ() - drones[j].getZ();
                    double distance = sqrt(dx*dx + dy*dy + dz*dz);
                    
                    if (distance < D) {
                        totalCollisionsCount++;
                    }
                }
            }

            for (int i = 0; i < N; ++i) {
                drones[i].chooseBestDirection(drones, i, r);
            }

            for (int i = 0; i < N; ++i) {
                drones[i].updatePosition();
            }
        }

        sumCollisionRates += (double)totalCollisionsCount / H;
    }


    double expectedCollisionRate = sumCollisionRates / M;


    ofstream rFile("results.txt");
    if (rFile.is_open()) {

        rFile << "2026-04-10-Carlo-DaRoma-2086036" << endl;
        rFile << "C " << fixed << setprecision(2) << expectedCollisionRate << endl;
        rFile.close();
    }

    return 0;
}