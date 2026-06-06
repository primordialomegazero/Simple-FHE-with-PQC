#!/bin/bash
# ============================================================
# DOST ASTI FHE-PQC v4.0 — QUICK VERIFICATION
# ============================================================

echo "=== Status ==="
curl -s http://localhost:8086/api | python3 -c "
import sys,json
d=json.load(sys.stdin)
libs=d.get('libs',[])
for l in libs: print(' ',l)
print('Engines:',d.get('engines_active','?'),'/4')
print('Source:',d.get('att',{}).get('src','N/A'))
"

echo ""
echo "=== Self-Test ==="
curl -s -X POST http://localhost:8086/api/self-test | python3 -c "
import sys,json
d=json.load(sys.stdin)
print(' ',d.get('perf_bar','N/A'))
print('  Add:',round(d.get('add_tps',0)/1e6,1),'M TPS | TRL:',d.get('trl_assessment',{}).get('trl_level','?'))
print('  Audit:',d.get('immutable_log',{}).get('ok','?'))
print('  ',d.get('timestamp_military',''))
"
