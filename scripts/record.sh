#!/bin/bash
# 录制所有 RealSense 话题到 rosbag
# 用法: ./record.sh [可选的文件名前缀]

set -e
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

PREFIX="${1:-recording}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BAG_DIR="/ros2_ws/data/${PREFIX}_${TIMESTAMP}"

echo "=== 开始录制到 ${BAG_DIR} ==="
echo "按 Ctrl+C 停止录制"

ros2 bag record -o "${BAG_DIR}" \
    /camera/color/image_raw \
    /camera/color/camera_info \
    /camera/depth/image_rect_raw \
    /camera/depth/camera_info \
    /camera/infra1/image_rect_raw \
    /camera/infra2/image_rect_raw \
    /camera/aligned_depth_to_color/image_raw \
    /camera/aligned_depth_to_color/camera_info \
    /camera/imu \
    /camera/gyro/imu_info \
    /camera/accel/imu_info \
    /tf \
    /tf_static \
    --storage mcap

echo "=== 录制完成: ${BAG_DIR} ==="
