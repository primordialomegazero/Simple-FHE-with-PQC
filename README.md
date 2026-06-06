# B5 FHE Quad Engine — DOST ASTI Pilot Kit

**Fully Homomorphic Encryption + Post-Quantum Cryptography**

## Quick Start

```bash
docker pull ghcr.io/primordialomegazero/dost-asti-fhe:latest
docker run -d -p 8086:8086 ghcr.io/primordialomegazero/dost-asti-fhe:latest
curl -X POST http://localhost:8086/api/self-test
Documentation
Technical Documentation (PDF attached)

Docker Deployment Guide (attached)

Function Reference (attached)

Research Context & Novelty Analysis (attached)

Test Suite
bash
bash test_suite.sh
COARE HPC Integration
bash
# SLURM Benchmark
sbatch coare-integration/slurm/b5_benchmark.job

# OpenStack Deployment
openstack stack create -t coare-integration/openstack/b5_fhe_stack.yaml b5-fhe

# CKAN Archiving
python3 coare-integration/ckan/b5_ckan_connector.py
Contact
Dan Joseph M. Fernandez
danfernandez9292@gmail.com

Source: I AM THAT I AM
