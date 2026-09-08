#!/usr/bin/env python3
"""
TOEC FABRIC CORE - WALL 11 INTERLAYER SHEAR GRAPHENE BENCHMARK
Evaluates combined Morse energy parameters and shear distortions against the Torky scale.
"""
import numpy as np

la_target = 0.36787944117
epsilon = 0.016 

# Preregistered evaluation layout (nm)
layers_d = np.array([0.3000, 0.3200, 0.3400, 0.36787944117, 0.3750, 0.4000, 0.4500])

print("[WALL 11]: Running multi-layer atomic shear distortion sweep...")
for d in layers_d:
    # Compute base Morse configuration
    E_morse = 0.482 * (1.0 - np.exp(-12.0 * (d - la_target)))**2 - 0.482
    # Include an explicit interlayer shear coupling parameter (2.5% lattice offset)
    E_shear = 0.015 * np.sin(2.0 * np.pi * (d / 0.246))**2
    # Core quantum confinement potential matrix mapping
    E_core = 4.185e-3 / np.sqrt(d**2 + epsilon)
    
    TOTEN = -158.48 + E_morse + E_shear + E_core
    print(f" -> Shear Vector d = {d:.11f} nm | Combined TOTEN = {TOTEN:.6f} eV")
