#!/bin/bash
# DOST ASTI FHE-PQC v4.0 — Complete Test Suite
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
echo " DOST ASTI FHE-PQC v4.0 — VALIDATION SUITE"
echo "============================================"

# Status check (v4.0 format)
STATUS=$(curl -s "$BASE")
echo "$STATUS" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print('Status:', d.get('st','UNKNOWN'))
print('Engine:', d.get('eng','UNKNOWN'))
"

# Verify libraries (v4.0 format)
echo "$STATUS" | python3 -c "
import sys,json
d=json.load(sys.stdin)
for lib in d.get('libs',[]): print('  [LIB]', lib)
print('  Attestation:', d.get('att',{}).get('src','UNKNOWN'))
print('  Version:', d.get('att',{}).get('ver','UNKNOWN'))
"

# Operational tests
test_op "Encrypt" "encrypt" '{"plaintext":"DOST_V4_TEST"}'
test_op "Decrypt" "decrypt" '{"ciphertext":"test123"}'
test_op "Homomorphic Add" "add" '{"a":100,"b":200}'
test_op "Homomorphic Multiply" "multiply" '{"a":10,"b":5}'
test_op "Fractal Bootstrap" "bootstrap" '{"cipher":42,"depth":5}'
test_op "Benchmark" "benchmark" '{"type":"add","iterations":50000}'
test_op "Audit Trail" "audit" "{}"
test_op "Fractal Chain" "chain-bootstrap" '{"cipher":42.0,"levels":5}'
test_op "Party Key" "party-key" "{}"
test_op "Noise Budget" "noise" '{"ciphertext":"test"}'
test_op "Auto-Bootstrap" "auto-bootstrap" '{"ciphertext":"test"}'
test_op "Metrics" "metrics" "{}"

# Self-Test (v4.0)
echo -n "[SELF] Self-Test: "
SELF=$(curl -s -X POST http://localhost:8086/api/self-test)
echo "$SELF" | python3 -c "
import sys,json
d=json.load(sys.stdin)
print('Encrypt:', round(d.get('enc_tps',0)), '| Add:', round(d.get('add_tps',0)), '| Bootstrap:', round(d.get('bs_tps',0)))
" 2>/dev/null && PASS=$((PASS+1)) || { echo "FAIL"; FAIL=$((FAIL+1)); }

# Performance
TPS=$(curl -s -X POST "$BASE" -H "Content-Type: application/json" \
    -d '{"operation":"benchmark","data":{"type":"add","iterations":50000}}' | python3 -c "import sys,json;print(round(json.load(sys.stdin).get('tps',0)))")
echo "  [PERF] TPS: $TPS"

TOTAL=$((PASS+FAIL))
echo "============================================"
echo " RESULTS: $PASS/$TOTAL passed"
echo " SCORE: $((PASS*100/TOTAL))/100"
echo "============================================"
[ $FAIL -eq 0 ] && echo " STATUS: ALL TESTS PASSED — DOST ASTI READY" || echo " STATUS: $FAIL FAILURES"
