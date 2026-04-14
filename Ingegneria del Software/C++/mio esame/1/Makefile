CC = g++
CFLAGS = -Wall -std=c++23

main: main.o Drone.o
	$(CC) $(CFLAGS) -o main main.o Drone.o

main.o: main.cpp Drone.h
	$(CC) $(CFLAGS) -c main.cpp

Drone.o: Drone.cpp Drone.h
	$(CC) $(CFLAGS) -c Drone.cpp

clean:
	rm -f *.o main