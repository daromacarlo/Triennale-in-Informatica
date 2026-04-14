#pragma once
#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>
#include <random>

struct Params {
    double H; int M; int C; int S; int F;
    double A; double B; double V; double W;
    int P; int Q; double r;
    double S0; double P0; double Q0;
    double SEP; double SOP; double QEA; double QOA;
    
    // Nuovi parametri Esercizio 4
    double a; double b; int G;
    
    // Assegnati dinamicamente dal ciclo in main.cpp, NON letti da file
    double ST0; double ST1; 
    
    // T per i costi di stoccaggio
    double T; 

    void load(const std::string& filename) {
        std::ifstream file(filename);
        if (!file.is_open()) {
            std::cerr << "ERRORE: Impossibile aprire " << filename << std::endl;
            exit(1);
        }

        std::string key;
        double value;
        std::map<std::string, double> p;
        while (file >> key >> value) {
            if (key == "Η") key = "H"; // Fix per Eta greco
            p[key] = value;
        }

        H = p["H"]; M = (int)p["M"]; C = (int)p["C"]; S = (int)p["S"]; F = (int)p["F"];
        A = p["A"]; B = p["B"]; V = p["V"]; W = p["W"];
        P = (int)p["P"]; Q = (int)p["Q"]; r = p["r"];
        S0 = p["S0"]; P0 = p["P0"]; Q0 = p["Q0"];
        SEP = p["SEP"]; SOP = p["SOP"]; QEA = p["QEA"]; QOA = p["QOA"];
        
        a = p["a"]; b = p["b"]; G = (int)p["G"];
        
        // Fallback robusto per T se non presente
        T = p.count("T") ? p["T"] : 1.0; 
    }
};

extern Params PARAMS;
extern std::mt19937 RNG;