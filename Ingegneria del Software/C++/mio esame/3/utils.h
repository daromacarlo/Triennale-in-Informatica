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
    double ST0; double ST1;
    double SEP; double SOP; double QEA; double QOA;
    double T; // <-- AGGIUNTO IL PARAMETRO T

    void load(const std::string& filename) {
        std::ifstream file(filename);
        std::string key;
        double value;
        std::map<std::string, double> p;
        while (file >> key >> value) p[key] = value;

        H = p["H"]; M = (int)p["M"]; C = (int)p["C"]; S = (int)p["S"]; F = (int)p["F"];
        A = p["A"]; B = p["B"]; V = p["V"]; W = p["W"];
        P = (int)p["P"]; Q = (int)p["Q"]; r = p["r"];
        S0 = p["S0"]; P0 = p["P0"]; Q0 = p["Q0"];
        ST0 = p["ST0"]; ST1 = p["ST1"];
        SEP = p["SEP"]; SOP = p["SOP"]; QEA = p["QEA"]; QOA = p["QOA"];
        T = p["T"]; // <-- LETTURA DEL PARAMETRO T
    }
};

extern Params PARAMS;
extern std::mt19937 RNG;