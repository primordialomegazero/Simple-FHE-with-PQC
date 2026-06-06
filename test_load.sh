#!/bin/bash
# ============================================================
# DOST ASTI FHE-PQC v4.0 — LOAD TEST SUITE
# ============================================================

GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  DOST ASTI FHE-PQC v4.0 — LOAD TEST SUITE${NC}"
echo -e "${CYAN}================================================================${NC}"

echo ""
echo "Test 1: 10 Concurrent Users, 100 Requests"
ab -n 100 -c 10 -s 30 http://localhost:8086/api 2>&1 | grep -E "Requests per second|Failed|Time per request"

echo ""
echo "Test 2: 50 Concurrent Users, 500 Requests"
ab -n 500 -c 50 -s 30 http://localhost:8086/api 2>&1 | grep -E "Requests per second|Failed|Time per request"

echo ""
echo "Test 3: 100 Concurrent Users, 1000 Requests"
ab -n 1000 -c 100 -s 30 http://localhost:8086/api 2>&1 | grep -E "Requests per second|Failed|Time per request"

echo ""
echo -e "Test 4: Self-Test Under Load (50 concurrent)"
ab -n 500 -c 50 -s 30 http://localhost:8086/api &
sleep 1
curl -s -X POST http://localhost:8086/api/self-test | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(f\"  Add TPS Under Load: {round(d.get('add_tps',0)/1e6,1)}M\")
print(f\"  Performance: {d.get('perf_bar','N/A')}\")
" 2>/dev/null
wait

echo ""
echo -e "${CYAN}================================================================${NC}"
echo -e "  ${GREEN}LOAD TEST COMPLETE${NC}"
echo -e "${CYAN}================================================================${NC}"
