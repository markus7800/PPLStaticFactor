# Static Factorisation of Probabilistic Programs With User-Labelled Sample Statements and While Loops

Overview:
```
.  
├── evaluation/
│     ├── benchmark/
│     │     └── generated/ 
│     ├── custom/
│     ├── finite/
│     ├── unrolled/
│     │     └── generated/ 
│     ├── bench.jl
│     ├── paper_results/
│     └── ppl.jl
│
├── src/   
│     ├── formal/
│     └── static/
├── generate_factorisation.py
├── print_results.py
└── run_benchmark.py
```

## Setup

No special hardware is needed for installation.

Recommendations:
- Hardware: >= 3.5 GHZ dual core CPU, >= 8 GB RAM, and >= 10 GB storage
- OS: unix-based operating system
- Installation with Docker

### Docker Installation

Install [docker](https://www.docker.com).

Build the pplstaticfactor image (this may take several minutes):
```
docker build -t pplstaticfactor .
```

If the build was successful, run the docker image:
```
docker run -it --name pplstaticfactor --rm pplstaticfactor
```

## Replication of Paper

Generate the sub-programs:
```
python3 generate_factorisation.py
```

Run benchmarks:
```
python3 run_benchmark.py
```
The results are written to `evaluation/results.csv`.
The results reported in the paper can be found in  `evaluation/paper_results.csv` (measure on a M2 Pro CPU).