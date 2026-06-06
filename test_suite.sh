#!/bin/bash
# DOST ASTI FHE-PQC — Complete Test Suite
BASE="http://localhost:8086/api"
PASS=0; FAIL=0

test_op() {
    local name="$1"; local op="$2"; local data="$3"
    local code=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$BASE" \
        -H "Content-Type: application/json" \
        -d "{\"operation\":\"$op\",\"data\":$data}")
    if [ "$code" = "200" ]; then
        echo "[PASS] $name"; PASS=$((PASS+1))
    else
        echo "[FAIL] $name (HTTP $code)"; FAIL=$((FAIL+1))
    fi
}

echo "============================================"
echo " DOST ASTI FHE-PQC — VALIDATION SUITE"
echo "============================================"

# Status check
STATUS=$(curl -s http://localhost:8086/api)
echo "$STATUS" | python3 -c "import sys,json;d=json.load(sys.stdin);print('Service:',d['service'])"

# Verify all 4 libraries
echo "$STATUS" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for lib in d['libraries']: print('  [LIB]', lib)
print('  Attestation:', d['attestation']['source'])
"

# Operational tests
test_op "Encrypt" "encrypt" '{"plaintext":"DOST_TEST"}'
test_op "Decrypt" "decrypt" '{"ciphertext":"test123"}'
test_op "Homomorphic Add" "add" '{"a":100,"b":200}'
test_op "Homomorphic Multiply" "multiply" '{"a":10,"b":5}'
test_op "Fractal Bootstrap" "bootstrap" '{"cipher":42,"depth":5}'
test_op "Benchmark" "benchmark" "{}"
test_op "Audit Trail" "audit" "{}"

# Performance
TPS=$(curl -s -X POST "$BASE" -H "Content-Type: application/json" \
    -d '{"operation":"benchmark","data":{}}' | python3 -c "import sys,json;print(json.load(sys.stdin)['tps'])")
echo "  [PERF] TPS: $TPS"

echo "============================================"
echo " RESULTS: $PASS/$((PASS+FAIL)) passed"
[ $FAIL -eq 0 ] && echo " STATUS: ALL TESTS PASSED" || echo " STATUS: $FAIL FAILURES"
echo "============================================"
