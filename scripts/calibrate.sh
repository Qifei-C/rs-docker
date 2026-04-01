#!/bin/bash
# D455 动态校准 (On-Chip Calibration)
# 使用 rs-self-calibration 工具进行深度质量校准

set -e

echo "=== Intel RealSense D455 校准工具 ==="
echo ""
echo "可用的校准方式:"
echo "  1) 动态校准 (推荐) - rs-self-calibration"
echo "  2) 深度质量检查 - rs-depth-quality"
echo "  3) 查看相机内参 - rs-enumerate-devices"
echo ""
read -p "选择 (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "=== 开始动态校准 ==="
        echo "请将相机对准一面平坦的白墙，距离 0.5-2m"
        echo ""
        rs-self-calibration
        ;;
    2)
        echo ""
        echo "=== 深度质量检查 ==="
        rs-depth-quality
        ;;
    3)
        echo ""
        echo "=== 设备信息与内参 ==="
        rs-enumerate-devices -c
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac
