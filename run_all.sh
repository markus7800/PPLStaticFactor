#!/bin/bash

python3 run_lmh_benchmark.py 10
python3 compare/gen/run_lmh.py 10
python3 compare/webppl/run_lmh.py 10

python3 run_vi_benchmark.py 10
python3 compare/pyro_bbvi/run_vi.py 1

python3 run_smc_benchmark.py 10
python3 compare/webppl/run_smc.py 10