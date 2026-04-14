CXX = g++
CXXFLAGS = -std=c++23 -Wall -Wextra -O3

SRCS = main.cpp network.cpp db.cpp server.cpp customer.cpp supplier.cpp
OBJS = $(SRCS:.cpp=.o)
TARGET = main

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f *.o $(TARGET)