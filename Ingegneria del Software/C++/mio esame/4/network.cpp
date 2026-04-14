#include "network.h"

Network NET;

void Network::schedule(double delay, std::function<void()> action) {
    events.push({current_time + delay, action});
}

void Network::run(double max_time) {
    while (!events.empty()) {
        Event e = events.top();
        if (e.time > max_time) break;
        events.pop();
        current_time = e.time;
        e.action();
    }
}