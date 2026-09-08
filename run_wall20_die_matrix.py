#!/usr/bin/env python3
import numpy as np
print("========================================================================================")
print("   TOEC WALL 20 — MULTI-MODULE CHIP DIE AREA & POWER DISTRIBUTION NETWORK MATRIX")
print("   THEORY OF EVERYTHING FABRIC — MASTER SYSTEM AUTHOR: AMR TORKY")
print("========================================================================================")
frozen_cells = 7725
base_cell_area = 355.35
io_pads_count = 48
io_pad_area_um2 = 120.0
gross_die_area_um2 = (base_cell_area + (io_pads_count * io_pad_area_um2)) * 1.35
print(f" -> Total Static Silicon Cells : {frozen_cells}")
print(f" -> Integrated IO Pad Blocks  : {io_pads_count}")
print(f" -> Computed Gross Die Area    : {gross_die_area_um2:.2f} um^2")
print("----------------------------------------------------------------------------------------")
core_voltage_rails = np.array([1.20, 1.10, 1.00, 0.90, 0.85])
for v in core_voltage_rails:
    dynamic_power_mw = frozen_cells * 0.00045 * (v ** 2) * 100.0
    static_leakage_mw = 0.085 * frozen_cells * (1.20 / v)
    total_power_mw = dynamic_power_mw + static_leakage_mw
    required_pwr_straps = int(np.ceil(total_power_mw / 15.0))
    print(f" -> Supply VDD = {v:.2f} V | Dynamic P = {dynamic_power_mw:6.2f} mW | Leakage = {static_leakage_mw:5.2f} mW | Total = {total_power_mw:6.2f} mW | Metal Straps = {required_pwr_straps}")
print("========================================================================================")
print("STATUS: WALL 20 MULTI-MODULE CHIP PHYSICAL MATRICES FULLY COMPILED.")
print("========================================================================================")
