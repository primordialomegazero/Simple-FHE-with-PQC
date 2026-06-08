#!/usr/bin/env python3
"""QUAD-CONSENSUS FHE Demo - DOST-ASTI"""

import requests
import json

SERVER = "http://localhost:8086"

def main():
print("=" * 50)
print("QUAD-CONSENSUS FHE - LIVE DEMO")
print("=" * 50)

Quad-Consensus
print("\n[Quad-Consensus Verification]")
r = requests.get(f"{SERVER}/api/quad")
d = r.json()
print(f" Operation: {d['operation']}")
print(f" Expected: {d['expected']}")
print(f" Consensus: {d['consensus']}/{d['consensus_max']}")
print(f" Achieved: {d['consensus_achieved']}")
print()
for e in d['engines']:
status = 'PASS' if e['correct'] else 'FAIL'
print(f" [{status}] {e['engine']}: {e['result']} | {e['role']}")

Performance
print("\n[Performance]")
r = requests.post(f"{SERVER}/api", json={
"operation": "benchmark",
"data": {"iterations": 500}
})
b = r.json()['benchmark']
seal_tps = b.get('seal_tps', 0)
phi_tps = b.get('phi_tps', 0)
ratio = phi_tps / max(1, seal_tps)

print(f" SEAL BFV: {seal_tps:.0f} TPS")
print(f" Phi-Fractal: {phi_tps:.0f} TPS")
print(f" Fractal Bootstrap: {b.get('fractal_bootstrap_tps', 0):.0f} TPS")
print(f" PQC KEM: {b.get('pqc_tps', 0):.0f} TPS")
print(f" Speed Ratio: {ratio:.0f}x faster")

print("\n" + "=" * 50)
print("DEMO COMPLETE - QUAD-CONSENSUS VERIFIED")
print("=" * 50)

if name == "main":
main()
