#ifndef DRONE_H
#define DRONE_H

class Drone {
public:

    Drone(double L, double V, double T, double a, double b);
    
    void updateState();
    
    double getX() const { return x; }
    double getY() const { return y; }
    double getZ() const { return z; }

private:
    double x, y, z;    
    double theta, phi; 
    double V, T, a, b;   // Parametri 
};

#endif