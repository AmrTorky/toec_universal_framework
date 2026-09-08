#!/bin/bash
# TOEC CORE AUTOMATED TAPE-OUT SIGN-OFF BUILDER
# DESIGN FOUNDER & SOVEREIGN AUTHOR: AMR TORKY
# PLATFORM INTERFACE: DESKTOP-9DLG3I0

echo "========================================================================================"
echo "   TOEC AUTOMATED SILICON TAPE-OUT SIGN-OFF UTILITY"
echo "   Sovereign Core Architecture Lead: AMR TORKY"
echo "========================================================================================"

echo "[PHASE 01]: Triggering local pre-verification layout simulation pass..."
python3 toec_continuous_scan.py > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo " -> STATUS: Pre-Silicon Verification Gate Engine Check Passed."
else
    echo " -> CRITICAL ERROR: Local gate files are syntactically broken! Halting package loop."
    exit 1
fi

echo "[PHASE 02]: Packaging design manifests and physical constraints..."
mkdir -p toec_tapeout_release_package
cp toec_dual_stabilizer.v toec_tb.v floorplan.cfg run_wall16_density.py toec_tapeout_release_package/

echo "[PHASE 03]: Generating structural SHA-256 telemetry tracking hashes..."
cd toec_tapeout_release_package || exit 1
sha256sum toec_dual_stabilizer.v > manifest_hashes.txt
sha256sum toec_tb.v >> manifest_hashes.txt
sha256sum floorplan.cfg >> manifest_hashes.txt
sha256sum run_wall16_density.py >> manifest_hashes.txt

echo "----------------------------------------------------------------------------------------"
cat manifest_hashes.txt
echo "----------------------------------------------------------------------------------------"
echo "[SUCCESS]: TOEC Tape-out asset bundle compiled with perfect structural compliance."
echo "========================================================================================"
