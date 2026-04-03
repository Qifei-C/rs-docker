#!/usr/bin/env bash
set -euo pipefail

# ===== Env =====
set +u
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash
set -u

echo "[INFO] ROS distro loaded: humble"

# ===== Launch RealSense for D455 (Stereo-IMU Only) =====
# 仅保留双目红外流用于特征提取，关闭发射器以获取纯净灰度图
echo "[INFO] Launching d455_camera in Stereo-IMU mode..."

ros2 launch realsense2_camera rs_launch.py \
    camera_name:=d455_camera \
    enable_color:=false \
    enable_depth:=false \
    enable_infra1:=true \
    enable_infra2:=true \
    depth_module.infra_profile:=640,480,30 \
    depth_module.emitter_enabled:=0 \
    enable_sync:=true \
    enable_accel:=true \
    enable_gyro:=true \
    accel_fps:=200 \
    gyro_fps:=400 \
    unite_imu_method:=1
