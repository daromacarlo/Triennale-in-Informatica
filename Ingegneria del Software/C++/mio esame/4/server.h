#pragma once
#include <vector>
#include <tuple>
#include "db.h"

class Server {
    int id;
    double sellBuy = 0.0;
    double y = 0.0;
    DB* db;
    struct CacheItem { int q = 0; int v = 0; };
    std::vector<CacheItem> cache;

public:
    Server(int id, DB* db_ref);
    void handleCustomerRequest(int customer_id, int i, int q);
    void triggerCacheUpdate();
    void handleDBReply(int i, int k, int v);
    void updateCostPeriodic();
    
    double getRewardRate() {
        return sellBuy - y;
    }
};