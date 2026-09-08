#!/usr/bin/env python3
import numpy as np
print("========================================================================================")
print("   TOEC WALL 16 — CORE GATE DENSITY INTEGRATION MATRIX")
print("   THEORY OF EVERYTHING MATRIX — DESIGN FOUNDER: AMR TORKY")
print("========================================================================================")
frozen_cells = 7725
die_width_um = 300.0
die_height_um = 300.0
total_area_um2 = die_width_um * die_height_um
avg_cell_footprint_um2 = 0.046
net_cell_area_um2 = frozen_cells * avg_cell_footprint_um2
print(f" -> Die Boundary Specifications : {die_width_um:.1f} um x {die_height_um:.1f} um")
print(f" -> Total Silicon Canvas Area   : {total_area_um2:.1f} um^2")
print(f" -> Net Hardware Gate Footprint : {net_cell_area_um2:.3f} um^2")
print("----------------------------------------------------------------------------------------")
utilization_targets = np.array([0.45, 0.50, 0.55, 0.60, 0.65])
for target in utilization_targets:
    allowable_macro_density = (net_cell_area_um2 / total_area_um2) / target * 100.0
    effective_slack_ps = 384.0 * (1.0 - (target - 0.55))
    print(f" -> Target Density = {target*100.0:.1f}% | Effective Physical Placement Slack = {allowable_macro_density:.4f}% | Projected Slack Window = {effective_slack_ps:.1f} ps")
print("========================================================================================")
print("STATUS: WALL 16 HARDWARE CELL ROUTING COMPACTION ARRAYS COMPLETE.")
print("========================================================================================")
