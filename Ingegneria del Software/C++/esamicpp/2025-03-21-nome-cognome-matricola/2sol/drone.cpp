#include "utils.hpp"
class Drone {
public:
    double X;
    double Y;
    double Z;
    bool stato;

public:
    Drone(){
        this->X = 0;
        this->Y = 0;
        this->Z = 0;
        this->stato = false;
    }
    // Costruttore (inizializza l'oggetto)
    void InializzaDrone(double X1, double X2, double Y1, double Y2, double Z1, double Z2) {
        this->X = randi_range(X1,X2);
        this->Y = randi_range(Y1,Y2);
        this->Z = randi_range(Z1,Z2);
        stato = true;
    }

    // Metodi (funzioni)
    void movimento(int t, double a, double X1, double X2, double Y1, double Y2, double Z1, double Z2){
        if (stato == true){
            double VX = randi_range(-a,a);
            double VY = randi_range(-a,a);
            double VZ = randi_range(-a,a);
            double newX = min(X2,max(X1, (this->X + VX*t)));
            double newY = min(Y2,max(Y1, (this->Y + VY*t)));
            double newZ = min(Z2,max(Z1, (this->Z + VZ*t)));
            this->Z = newZ;
            this->Y = newY;
            this->X = newX;
        }
    }

    void spegnimento() {
        stato = false;
    }
};