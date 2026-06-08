#!/bin/bash
SERVER="http://localhost:8086"
PASS=0
FAIL=0

test_case() {
local name="$1"
local result="$2"
if [ "
r
e
s
u
l
t
"
=
"
t
r
u
e
"
]
∣
∣
[
"
result"="true"]∣∣["result" = "True" ]; then
echo " [PASS] 
n
a
m
e
"
P
A
S
S
=
name"PASS=((PASS+1))
else
echo " [FAIL] 
n
a
m
e
"
F
A
I
L
=
name"FAIL=((FAIL+1))
fi
}

echo "QUAD-CONSENSUS FHE Test Suite"
echo "=============================="

echo ""
echo "--- Server Status ---"
STATUS=
(
c
u
r
l
−
s
(curl−sSERVER/api/status)
echo "$STATUS" | python3 -c "import sys,json;d=json.load(sys.stdin);print(f'Status: {d["status"]}');print(f'Version: {d["version"]}');print(f'Engines: {d["engines_active"]}/{d["engines_total"]}')"

echo ""
echo "--- Quad-Consensus ---"
QUAD=
(
c
u
r
l
−
s
(curl−sSERVER/api/quad)
CONSENSUS=
(
e
c
h
o
"
(echo"QUAD" | python3 -c "import sys,json;print(json.load(sys.stdin)['consensus_achieved'])")
test_case "Quad-Consensus 4/4" "$CONSENSUS"

echo ""
echo "--- SEAL BFV ---"
SEAL_ADD=
(
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
(curl−s−XPOSTSERVER/api -H "Content-Type: application/json" -d '{"operation":"seal-add","data":{"a":42,"b":58}}')
SEAL_OK=
(
e
c
h
o
"
(echo"SEAL_ADD" | python3 -c "import sys,json;print(json.load(sys.stdin)['correct'])")
test_case "SEAL Add (42+58=100)" "$SEAL_OK"

SEAL_MUL=
(
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
(curl−s−XPOSTSERVER/api -H "Content-Type: application/json" -d '{"operation":"seal-multiply","data":{"a":7,"b":6}}')
SEAL_MUL_OK=
(
e
c
h
o
"
(echo"SEAL_MUL" | python3 -c "import sys,json;print(json.load(sys.stdin)['correct'])")
test_case "SEAL Multiply (7x6=42)" "$SEAL_MUL_OK"

echo ""
echo "--- Phi-Fractal ---"
PHI_ENC=
(
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
(curl−s−XPOSTSERVER/api -H "Content-Type: application/json" -d '{"operation":"phi-encrypt","data":{"plaintext":"I AM THAT I AM"}}')
PHI_CT=
(
e
c
h
o
"
(echo"PHI_ENC" | python3 -c "import sys,json;print(json.load(sys.stdin).get('ciphertext','FAIL')[:32])")
test_case "Phi-Encrypt" "
(
[
"
(["PHI_CT" != "FAIL" ] && echo true || echo false)"

echo ""
echo "--- PQC ---"
PQC=
(
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
(curl−s−XPOSTSERVER/api -H "Content-Type: application/json" -d '{"operation":"pqc-encapsulate"}')
PQC_OK=
(
e
c
h
o
"
(echo"PQC" | python3 -c "import sys,json;print('shared_secret' in json.load(sys.stdin).get('kem',{}))")
test_case "PQC ML-KEM-1024" "$PQC_OK"

echo ""
echo "=============================="
echo "Results: 
P
A
S
S
p
a
s
s
e
d
,
PASSpassed,FAIL failed"
echo "=============================="
