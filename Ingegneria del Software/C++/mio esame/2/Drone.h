#ifndef DRONE_H
#define DRONE_H

#include <vector>

class Drone {
public:
    Drone(double L, double V, double T, double a, double b);
    

    void chooseBestDirection(const std::vector<Drone>& allDrones, int myIndex, double r);
    void updatePosition(); // Solo aggiornamento x, y, z

    double getX() const { return x; }
    double getY() const { return y; }
    double getZ() const { return z; }

private:
    double x, y, z;
    double theta, phi;
    double V, T, a, b;
};

#endif