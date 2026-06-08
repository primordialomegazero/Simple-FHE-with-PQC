#!/bin/bash
SERVER="http://localhost:8086"

echo "QUAD-CONSENSUS Benchmark Suite"
echo "==============================="

for iter in 100 500 1000; do
echo ""
echo "--- Iterations: 
i
t
e
r
−
−
−
"
c
u
r
l
−
s
−
X
P
O
S
T
iter−−−"curl−s−XPOSTSERVER/api -H "Content-Type: application/json"
-d "{"operation":"benchmark","data":{"iterations":$iter}}" |
python3 -c "
import sys,json
d=json.load(sys.stdin)
b=d.get('benchmark',{})
print(f' SEAL BFV: {b.get("seal_tps",0):.0f} TPS')
print(f' Phi-Fractal: {b.get("phi_tps",0):.0f} TPS')
print(f' Fractal Bootstrap: {b.get("fractal_bootstrap_tps",0):.0f} TPS')
print(f' PQC KEM: {b.get("pqc_tps",0):.0f} TPS')
if b.get('seal_tps',0) > 0:
print(f' Speed Ratio: {b.get("phi_tps",0)/b.get("seal_tps",1):.0f}x')
"
done
