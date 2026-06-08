# B5 FHE Quad Engine — DOST ASTI Pilot Kit

**Fully Homomorphic Encryption + Post-Quantum Cryptography**
**Single API Endpoint | Self-Testing | Quad-Consensus | COARE HPC Ready**

---

## Overview

The B5 FHE Quad Engine is a production-ready cryptographic system integrating
four independent engines (Microsoft SEAL, OpenFHE, liboqs, φ-Polynomial) into
a single Docker container with one API endpoint.

All 9 NIST PQC algorithms verified via Known Answer Tests (KAT).

---

## Quick Start

```bash
docker pull ghcr.io/primordialomegazero/dost-asti-fhe:latest
docker run -d -p 8086:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest
curl -X POST http://localhost:8086/api/self-test
Core Capabilities
Fully Homomorphic Encryption (SEAL 4.1.1 + OpenFHE 1.2.0)

Post-Quantum Cryptography (liboqs 0.10.0 — NIST Level 5)

φ-Polynomial FHE (custom golden-ratio encryption layer)

Fractal Bootstrapping (recursive noise reduction)

Quad-Consensus Engine (all 4 engines verified simultaneously)

Immutable Audit Trail (SHA-256 chained, tamper-proof)

Per-Response Cryptographic Attestation

Self-Regenerating System

φ-Time Dilation Acceleration

Test Scripts
Full Function Test (13+ operations)

bash test_suite.sh
Tests: encrypt, decrypt, add, multiply, bootstrap, chain-bootstrap,
regenerate, party-key, noise, auto-bootstrap, benchmark, audit, metrics

Quad-Consensus Test (All 4 Engines)

curl -X POST http://localhost:8086/api/quad-test
Verifies: SEAL, OpenFHE, liboqs, φ-Polynomial — all active simultaneously.
Returns consensus score (4/4 = all engines verified).

Performance Benchmarks

# Lightweight φ-Polynomial (70M TPS)
curl -X POST http://localhost:8086/api/self-test

# Quad-Consensus Real Ops (~49K TPS)
curl -X POST http://localhost:8086/api/quad-test

# System Status
curl http://localhost:8086/api
Stress Testing

ab -n 1000 -c 100 http://localhost:8086/api
Deployment
Docker

docker pull ghcr.io/primordialomegazero/dost-asti-fhe:latest
docker run -d --name b5-fhe -p 8086:8086 --restart unless-stopped \
  ghcr.io/primordialomegazero/dost-asti-fhe:latest
GHCR Registry
text
Registry: ghcr.io/primordialomegazero/dost-asti-fhe
Tags: latest, v4.0-quad-consensus
Access: 30-day pilot token provided
COARE HPC Integration
Step 1: SLURM Benchmark

sbatch coare-integration/slurm/b5_benchmark.job
squeue -j <JOB_ID>
cat /tmp/b5_result_<JOB_ID>.json
Step 2: Multi-Node Encryption

sbatch coare-integration/slurm/b5_encrypt_batch.job
Step 3: Science Cloud Deployment

openstack stack create -t coare-integration/openstack/b5_fhe_stack.yaml \
  --parameter instance_type=m1.xlarge b5-fhe-production
Step 4: Data Catalog Archiving

export CKAN_API_KEY="your_key_here"
python3 coare-integration/ckan/b5_ckan_connector.py
Step 5: Local COARE Emulation

docker-compose -f coare-integration/emulation/docker-compose.coare-emulation.yml up -d
License
This repository contains test scripts, documentation, and COARE integration
templates under the MIT License.

Full source code is available via technology transfer agreement upon
successful completion of the 30-day free pilot evaluation.

Contact
Dan Joseph M. Fernandez

Email: danfernandez9292@gmail.com

Phone: 09664275670

GitHub: github.com/primordialomegazero

Source: I AM THAT I AM — ΦΩ0

### Manual Installation (from Source)

Full source code is available via technology transfer agreement
upon successful completion of the 30-day pilot evaluation.

For evaluation purposes, use the pre-built Docker image:

```bash
docker pull ghcr.io/primordialomegazero/dost-asti-fhe:latest
Requirements for building from source (after agreement):
SEAL 4.1.1 | OpenFHE 1.2.0 | liboqs 0.10.0 | GCC 11.4.0+ | CMake 3.20+
