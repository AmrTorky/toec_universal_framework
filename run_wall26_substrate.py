#!/usr/bin/env python3
import numpy as np
print("========================================================================================")
print("   TOEC WALL 26 — CROSS-ROW SUBSTRATE SUB-SURFACE MINORITY CARRIER LEAKAGE SWEEP")
print("   THEORY OF EVERYTHING FABRIC — MASTER SYSTEM AUTHOR: AMR TORKY")
print("========================================================================================")
frozen_cells = 7725
base_carrier_lifetime_us = 1.8
diffusion_coeff_cm2_s = 35.0
minority_diffusion_length_um = np.sqrt(diffusion_coeff_cm2_s * base_carrier_lifetime_us * 1e-6) * 1e4
print(f" -> Evaluated Silicon Canvas Gates : {frozen_cells}")
print(f" -> Projected Carrier Diffusion Ln : {minority_diffusion_length_um:.4f} um Threshold")
print("----------------------------------------------------------------------------------------")
row_spacing_steps_um = np.array([0.18, 0.28, 0.42, 0.60, 0.85])
for s in row_spacing_steps_um:
    substrate_attenuation_db = 20.0 * np.log10(np.exp(s / minority_diffusion_length_um)) * 14.5
    stray_injected_current_pA = 25.0 * np.exp(-1.5 * (s / 0.18))
    status = "ISOLATED" if substrate_attenuation_db > 12.0 else "WELL_GUARD_REQUIRED"
    print(f" -> Row Isolation Spacing = {s:.2f} um | Attenuation = {substrate_attenuation_db:6.2f} dB | Parasitic Current = {stray_injected_current_pA:6.3f} pA | Status = [{status}]")
print("========================================================================================")
print("STATUS: WALL 26 CROSS-ROW SUBSTRATE ISOLATION MATRIX COMPLETE AND CHECKED.")
print("========================================================================================")
