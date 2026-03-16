#include "dtmc.cpp"
#include "drone.cpp"
#include <iostream>
int main(int argc, char **argv)
{
    srand((unsigned)time(NULL));
    setvbuf(stdout, NULL, _IONBF, 0);

    /*parametri*/
    int H = 1000;
    int N = 120;
    float A = 0.2;
    float R = 2;
    double X1 = -5;
    double Y1 = -2;
    double X2 = 10;
    double Y2 = 7;
    double Z1 = 1;
    double Z2 = 23;

    /*Lettura dei parametri*/
    ifstream file("parameters.txt"); 
    string line; 


    getline(file, line); 
    vector<string> tmp = splitString(line);
                                      
    if (tmp[0] == "H")
        H = stoi(tmp[1]);

    getline(file, line);
    tmp = splitString(line);
    if (tmp[0] == "N")
        N = stoi(tmp[1]);

    getline(file, line);
    if (tmp[0] == "A")
        A = stoi(tmp[1]);

    getline(file, line);
    if (tmp[0] == "R")
        R = stoi(tmp[1]);    

    getline(file, line);
    tmp = splitString(line);
    X1 = stof(tmp[0]); /*da stringa a float*/
    X2 = stof(tmp[1]);
    Y1 = stof(tmp[2]);
    Y2 = stof(tmp[3]);
    Z1 = stof(tmp[4]);
    Z2 = stof(tmp[5]);


    /*creaiamo un orda di droni*/
    std::vector<Drone> droni(N);

    for (Drone &p : droni){
        p.InializzaDrone(X1,X2,Y1,Y2,Z1,Z2);
    }

    for (int i = 0; i <= H; i++){
        for (Drone &p : droni){
            p.movimento(i,A,X1,X2,Y1,Y2,Z1,Z2);
            }

        for (Drone &p : droni){  
            for  (Drone &d : droni){
                if (&p != &d){
                    if ((sqrt(pow((d.X - p.X), 2) + pow((d.Y - p.Y),2) + pow((d.Z - p.Z),2))) < R) {
                        p.spegnimento();
                        d.spegnimento();
                    }
                }
                else{

                }
                }
            }
        }

    int q = 0;
    for (Drone &p : droni){
        if (p.stato == true){
            q++;
        }
    }


    ofstream output("results.txt");
    output << "2025-02-05-carlo-da-roma-2046212\n";
    {
        output << q << "\n" << N << "\n" << (double)q/N << "\n";
    }
    output.close();
    return 0;

};

