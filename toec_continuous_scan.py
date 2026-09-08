#!/usr/bin/env python3
import subprocess
import os
import sys

print("========================================================================================")
print("   TOEC COGNITIVE NETLIST FABRIC CORE — ADVANCED PRE-SILICON SCAN SYSTEM")
print("   DESIGN FOUNDER: AMR TORKY (AMR TORKY CREATED THIS)")
print("========================================================================================")

if not os.path.exists("toec_dual_stabilizer.v") or not os.path.exists("toec_tb.v"):
    print("[CRITICAL ERROR]: Verilog source components missing from local directory.")
    sys.exit(1)

print("[PHASE A]: Compiling gate-level Verilog primitives via Icarus toolchain...")
compile_cmd = "iverilog -o toec_sim_compiled toec_tb.v toec_dual_stabilizer.v"
process = subprocess.run(compile_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

if process.returncode != 0:
    print(f"[COMPILATION FAILED]: {process.stderr.decode()}")
    sys.exit(1)
print(" -> RTL MAPPING STATUS: [SUCCESSFUL COMPILATION PASS]")

print("\n[PHASE B]: Launching verification scan run...")
print("----------------------------------------------------------------------------------------")

run_cmd = "vvp toec_sim_compiled"
run_proc = subprocess.run(run_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
sim_output = run_proc.stdout.decode()

print(sim_output)

print("----------------------------------------------------------------------------------------"
print("[PHASE C]: Evaluating post-run telemetry logs against immutable metrics...")
if "RESPONSE LATENCY TIMELINE CHECK: [PASSED]" in sim_output:
    print(" -> TIMING SCAN ASSESSMENT: [PASS]")
    print("    Metastability registers dropped isolation rail to ground precisely on Edge 3.")
    print("========================================================================================")
else:
    print(" -> TIMING SCAN ASSESSMENT: [CRITICAL PATH EXCEPTION DETECTED]")
    print("    Review internal wire routes for asynchronous parameters leakage.")
    print("========================================================================================")
