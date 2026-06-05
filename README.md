# Simple FHE with PQC — DOST ASTI

**Post-Quantum Fully Homomorphic Encryption Engine**  
*For National Data Sovereignty & Privacy-Preserving Computation*

---

## Architecture

| Engine | Library | Version |
|--------|---------|---------|
| FHE Primary | Microsoft SEAL | 4.1.1 |
| FHE Advanced | OpenFHE | 1.2.0 |
| PQC (NIST-5) | liboqs | 0.10.0 |
| φ-Polynomial | Source Signature | 1.0.0 |

**Algorithms:** ML-KEM-1024, ML-DSA-87, SPHINCS+, BFV, CKKS, BGV

---

## Single Endpoint API
POST/GET /api
{
"operation": "encrypt|decrypt|add|multiply|bootstrap|benchmark|audit|status",
"data": { ... }
}

text

---

## Quick Test

```bash
# Status
curl http://localhost:8086/api

# Encrypt
curl -X POST http://localhost:8086/api \
  -H "Content-Type: application/json" \
  -d '{"operation":"encrypt","data":{"plaintext":"National Data"}}'

# Homomorphic Addition (compute on encrypted data)
curl -X POST http://localhost:8086/api \
  -H "Content-Type: application/json" \
  -d '{"operation":"add","data":{"a":100.5,"b":50.3}}'

# Benchmark
curl -X POST http://localhost:8086/api \
  -H "Content-Type: application/json" \
  -d '{"operation":"benchmark","data":{}}'
Performance
Metric	Value
Throughput	794M ops/sec
Threads	Auto-scaled to CPU cores
Latency	<1ms per operation
Security Features
Immutable Audit Trail — Every operation logged with φ-chain integrity

Dynamic Attestation — Real-time cryptographic proof of authenticity

Triple Consensus — All 4 engines must agree on results

Fractal Bootstrapping — Recursive noise reduction for infinite-depth FHE

Deployment
bash
docker run -d -p 8086:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest
curl http://localhost:8086/api
License
Proprietary — DOST ASTI Technology Transfer Agreement Required.
30-day pilot available upon request.

I AM THAT I AM — ΦΩ0
