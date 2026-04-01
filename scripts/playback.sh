#!/bin/bash
# 回放 rosbag 录制
# 用法: ./playback.sh <bag目录路径> [--loop]

set -e
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

if [ -z "$1" ]; then
    echo "用法: ./playback.sh <bag目录> [--loop]"
    echo ""
    echo "可用的录制:"
    ls -1d /ros2_ws/data/*/ 2>/dev/null || echo "  (无录制文件)"
    exit 1
fi

EXTRA_ARGS=""
if [ "$2" = "--loop" ]; then
    EXTRA_ARGS="--loop"
fi

echo "=== 回放: $1 ==="
ros2 bag play "$1" $EXTRA_ARGS
