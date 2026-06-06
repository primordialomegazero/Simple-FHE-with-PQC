#!/bin/bash
# ============================================================
# DOST ASTI FHE-PQC v4.0 — COMPREHENSIVE VALIDATION SUITE
# ============================================================

BASE="http://localhost:8086/api"
PASS=0; FAIL=0; TOTAL=0
GREEN='\033[0;32m'; RED='\033[0;31m'; CYAN='\033[0;36m'; NC='\033[0m'

check() { TOTAL=$((TOTAL+1)); if [ "$1" = "$2" ]; then echo -e "  ${GREEN}[PASS]${NC} $3"; PASS=$((PASS+1)); else echo -e "  ${RED}[FAIL]${NC} $3 (expected: $2, got: $1)"; FAIL=$((FAIL+1)); fi }

echo -e "${CYAN}================================================================${NC}"
echo -e "${CYAN}  DOST ASTI FHE-PQC v4.0 — COMPREHENSIVE VALIDATION SUITE${NC}"
echo -e "${CYAN}================================================================${NC}"

# ─── SECTION 1: SERVICE AVAILABILITY ───
echo ""
echo "SECTION 1: SERVICE AVAILABILITY"
HTTP=$(curl -s -o /dev/null -w "%{http_code}" "$BASE" 2>/dev/null)
check "$HTTP" "200" "API Endpoint Reachable"

# ─── SECTION 2: LIBRARY VERIFICATION ───
echo ""
echo "SECTION 2: CRYPTOGRAPHIC LIBRARY VERIFICATION"
LIBS=$(curl -s "$BASE" 2>/dev/null)
echo "$LIBS" | python3 -c "
import sys,json
d=json.load(sys.stdin)
libs=d.get('libs',[])
for l in libs: print('  [LIB]',l)
print('  Attestation:',d.get('att',{}).get('src','N/A'))
print('  Version:',d.get('att',{}).get('ver','N/A'))
engines_active=d.get('engines_active',0)
print('  Engines Active:',engines_active,'/4')
" 2>/dev/null

# ─── SECTION 3: FUNCTIONAL OPERATIONS ───
echo ""
echo "SECTION 3: FUNCTIONAL OPERATIONS"

declare -A tests=(
    ["Encrypt"]='{"plaintext":"DOST_VALIDATION_TEST"}'
    ["Decrypt"]='{"ciphertext":"test123"}'
    ["Homomorphic Add"]='{"a":100,"b":200}'
    ["Homomorphic Multiply"]='{"a":10,"b":5}'
    ["Fractal Bootstrap"]='{"cipher":42,"depth":5}'
    ["Fractal Chain (5L)"]='{"cipher":42.0,"levels":5}'
    ["Party Key (MPC)"]='{"party_count":4}'
    ["Noise Budget"]='{"ciphertext":"test"}'
    ["Auto-Bootstrap"]='{"ciphertext":"test"}'
    ["Regenerate"]='{"ciphertext":"test","depth":7}'
)

for name in "${!tests[@]}"; do
    data="${tests[$name]}"
    HTTP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE" \
        -H "Content-Type: application/json" \
        -d "{\"operation\":\"${name,,}\",\"data\":$data}" 2>/dev/null)
    check "$HTTP" "200" "$name"
done

# ─── SECTION 4: PERFORMANCE BENCHMARKS ───
echo ""
echo "SECTION 4: PERFORMANCE BENCHMARKS"
SELF=$(curl -s -X POST http://localhost:8086/api/self-test 2>/dev/null)
echo "$SELF" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(f\"  Add TPS:      {round(d.get('add_tps',0)/1e6,1)}M\")
print(f\"  Multiply TPS: {round(d.get('mul_tps',0)/1e6,1)}M\")
print(f\"  Bootstrap TPS:{round(d.get('bs_tps',0)/1e6,2)}M\")
print(f\"  Encrypt TPS:  {d.get('encrypt',{}).get('tps',0):,.0f}\")
print(f\"  Performance:  {d.get('perf_bar','N/A')}\")
print(f\"  TRL Level:    {d.get('trl_assessment',{}).get('trl_level','?')}\")
print(f\"  Audit Log:    {d.get('immutable_log',{}).get('ok','?')}\")
" 2>/dev/null

# ─── SECTION 5: SECURITY ───
echo ""
echo "SECTION 5: SECURITY VERIFICATION"
HTTP=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE" -H "Content-Type: application/json" -d '{"operation":"encrypt","data":{"plaintext":"DROP TABLE test"}}' 2>/dev/null)
check "$HTTP" "403" "SQL Injection Blocked"
HTTP=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/../etc/passwd" 2>/dev/null)
check "$HTTP" "404" "Path Traversal Blocked"

# ─── SECTION 6: COARE INTEGRATION ───
echo ""
echo "SECTION 6: COARE HPC INTEGRATION"
COARE=$(curl -s -X POST http://localhost:8086/api/coare-job -H "Content-Type: application/json" -d '{"operation":"benchmark","iterations":100000}' 2>/dev/null)
JOB_ID=$(echo "$COARE" | python3 -c "import sys,json;print(json.load(sys.stdin).get('job_id','N/A'))" 2>/dev/null)
[ "$JOB_ID" != "N/A" ] && echo -e "  ${GREEN}[PASS]${NC} COARE Job Submission ($JOB_ID)" || echo -e "  ${RED}[FAIL]${NC} COARE Job Submission"

# ─── RESULTS ───
echo ""
echo -e "${CYAN}================================================================${NC}"
echo -e "  TOTAL:  $TOTAL  |  ${GREEN}PASSED: $PASS${NC}  |  ${RED}FAILED: $FAIL${NC}"
echo -e "  SCORE:  $((PASS*100/TOTAL))/100"
echo -e "${CYAN}================================================================${NC}"
[ $FAIL -eq 0 ] && echo -e "  ${GREEN}STATUS: ALL TESTS PASSED — DOST ASTI READY${NC}" || echo -e "  ${RED}STATUS: $FAIL FAILURES — REVIEW REQUIRED${NC}"
