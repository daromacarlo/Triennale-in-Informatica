#include "Drone.h"
#include <cmath>
#include <random>

// Generatore di numeri casuali statico per efficienza
static std::mt19937 gen(std::random_device{}());

Drone::Drone(double L, double V, double T, double a, double b) 
    : V(V), T(T), a(a), b(b) {
    std::uniform_real_distribution<double> distL(-L, L);
    std::uniform_real_distribution<double> distTheta(0, M_PI);
    std::uniform_real_distribution<double> distPhi(0, 2 * M_PI);

    x = distL(gen);
    y = distL(gen);
    z = distL(gen);
    theta = distTheta(gen);
    phi = distPhi(gen);
}

void Drone::updateState() {
    // 1. Aggiornamento angoli con u_i, w_i in {-1, 0, 1} [cite: 36, 38]
    std::uniform_int_distribution<int> distUWB(-1, 1);
    theta += T * a * distUWB(gen);
    phi += T * b * distUWB(gen);

    // 2. Calcolo componenti velocità [cite: 18, 19, 20]
    double vx = V * std::sin(theta) * std::cos(phi);
    double vy = V * std::sin(theta) * std::sin(phi);
    double vz = V * std::cos(theta);

    // 3. Aggiornamento posizione [cite: 11]
    x += T * vx;
    y += T * vy;
    z += T * vz;
}