#!/usr/bin/env python3
"""
TOEC FABRIC CORE - PHYSICAL GDSII GENERATOR
Streams the Center-Die Matrix Floor layout rules down to structural boundaries.
"""
import gdspy
import numpy as np

# Initialize the Master GDSII Library container
lib = gdspy.GdsLibrary(name="TOEC_Universal_Master_Core", unit=1e-6, precision=1e-9)
cell = lib.new_cell("CENTER_DIE_MATRIX_FLOOR")

# 1. Outer Target Die Boundary [300.0 µm x 300.0 µm]
die_rect = gdspy.Rectangle((0, 0), (300.0, 300.0), layer=0, datatype=0)
cell.add(die_rect)

# 2. Hardwired Cognitive Neural Mesh floorplan bounding box
# Restrained exactly within the audited [100.0, 100.0] to [200.0, 200.0] µm zone
mesh_rect = gdspy.Rectangle((100.0, 100.0), (200.0, 200.0), layer=46, datatype=1)
cell.add(mesh_rect)

# 3. Micro-scale Transistor Dielectric Layer Invariant Mapping
# Etching the verified Torky horizon (0.36788 nm / 0.016 nm² Core regularizer)
pitch_um = 0.36787944117
for x in np.arange(110.0, 190.0, 10.0):
    for y in np.arange(110.0, 190.0, 10.0):
        # Place localized sub-micron solid-state stabilization vias using 'radius'
        via = gdspy.Round((x, y), radius=pitch_um, layer=50, datatype=0)
        cell.add(via)

# Export structural definitions to raw binary mask layout format
lib.write_gds("toec_center_die_floorplan.gds")
print("[GDSII STREAM SUCCESS]: 'toec_center_die_floorplan.gds' written cleanly.")
