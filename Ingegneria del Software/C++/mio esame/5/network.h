#pragma once
#include <queue>
#include <functional>
#include <vector>
struct Event {
    double time;
    std::function<void()> action;
    bool operator>(const Event& other) const { return time > other.time; }
};
class Network {
    std::priority_queue<Event, std::vector<Event>, std::greater<Event>> events;
    double current_time = 0.0;
public:
    void schedule(double delay, std::function<void()> action);
    void run(double max_time);
    double getTime() const { return current_time; }
    void reset() {
        events = std::priority_queue<Event, std::vector<Event>, std::greater<Event>>();
        current_time = 0.0;
    }
};
extern Network NET;