#include "Drone.h"
#include <cmath>
#include <random>
#include <algorithm>

static std::mt19937 gen(std::random_device{}());

Drone::Drone(double L, double V, double T, double a, double b) 
    : V(V), T(T), a(a), b(b) {
    std::uniform_real_distribution<double> distL(-L, L);
    std::uniform_real_distribution<double> distTheta(0, M_PI);
    std::uniform_real_distribution<double> distPhi(0, 2 * M_PI);

    x = distL(gen); y = distL(gen); z = distL(gen);
    theta = distTheta(gen); phi = distPhi(gen);
}

void Drone::chooseBestDirection(const std::vector<Drone>& allDrones, int myIndex, double r) {
    std::vector<const Drone*> neighbors;
    for (int j = 0; j < (int)allDrones.size(); ++j) {
        if (j == myIndex) continue;
        double dx = x - allDrones[j].x;
        double dy = y - allDrones[j].y;
        double dz = z - allDrones[j].z;
        if (std::sqrt(dx*dx + dy*dy + dz*dz) <= r) {
            neighbors.push_back(&allDrones[j]);
        }
    }

    if (neighbors.empty()) {
        std::uniform_int_distribution<int> dist(-1, 1);
        theta += T * a * dist(gen);
        phi += T * b * dist(gen);
        return;
    }

    // Step 2: Ottimizzazione su 9 possibilità [cite: 178-202]
    double maxMinDist = -1.0;
    std::vector<std::pair<int, int>> bestPairs;

    for (int u : {-1, 0, 1}) {
        for (int w : {-1, 0, 1}) {
            double nt = theta + T * a * u;
            double np = phi + T * b * w;

            auto getV = [&](double th, double ph) {
                return std::vector<double>{V * sin(th) * cos(ph), V * sin(th) * sin(ph), V * cos(th)};
            };
            
            std::vector<double> vT = getV(theta, phi);
            std::vector<double> vT1 = getV(nt, np);

            double nx2 = x + T * vT[0] + T * vT1[0];
            double ny2 = y + T * vT[1] + T * vT1[1];
            double nz2 = z + T * vT[2] + T * vT1[2];


            double currentMin = 1e18;
            for (auto neighbor : neighbors) {
                double dx = nx2 - neighbor->x;
                double dy = ny2 - neighbor->y;
                double dz = nz2 - neighbor->z;
                currentMin = std::min(currentMin, std::sqrt(dx*dx + dy*dy + dz*dz));
            }

            if (currentMin > maxMinDist + 1e-9) {
                maxMinDist = currentMin;
                bestPairs = {{u, w}};
            } else if (std::abs(currentMin - maxMinDist) < 1e-9) {
                bestPairs.push_back({u, w});
            }
        }
    }


    std::uniform_int_distribution<int> choice(0, bestPairs.size() - 1);
    auto best = bestPairs[choice(gen)];
    theta += T * a * best.first;
    phi += T * b * best.second;
}

void Drone::updatePosition() {
    x += T * (V * sin(theta) * cos(phi));
    y += T * (V * sin(theta) * sin(phi));
    z += T * (V * cos(theta));
}