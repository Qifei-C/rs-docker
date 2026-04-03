#!/usr/bin/env bash
set -euo pipefail

# ===== Config =====
BAG_NAME="${1:-D455_Stereo_IMU_$(date +%Y%m%d_%H%M%S)}"
OUT_DIR="${2:-/ros2_ws/data}"
DURATION_SEC="${3:-}"

# ===== Env =====
set +u
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash
set -u

mkdir -p "$OUT_DIR"
cd "$OUT_DIR"

echo "[INFO] Output: $OUT_DIR/$BAG_NAME"
echo "[INFO] Storage: mcap (Optimized for Foxglove/Calibration)"

TOPICS=(
    /camera/d455_camera/infra1/image_rect_raw
    /camera/d455_camera/infra1/camera_info
    /camera/d455_camera/infra2/image_rect_raw
    /camera/d455_camera/infra2/camera_info
    /camera/d455_camera/imu
    /tf_static
)

if [[ -n "$DURATION_SEC" ]]; then
    echo "[INFO] Recording for ${DURATION_SEC}s..."
    timeout "${DURATION_SEC}" ros2 bag record --storage mcap -o "$BAG_NAME" "${TOPICS[@]}" || true
    echo "[INFO] Done (timeout reached)."
else
    echo "[INFO] Recording... press Ctrl+C to stop."
    ros2 bag record --storage mcap -o "$BAG_NAME" "${TOPICS[@]}"
fi

echo "[INFO] Bag saved at: $OUT_DIR/$BAG_NAME"
