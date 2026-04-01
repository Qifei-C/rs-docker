#!/bin/bash
set -e

# source ROS2 humble
source /opt/ros/humble/setup.bash

# source realsense workspace
if [ -f /ros2_ws/install/setup.bash ]; then
    source /ros2_ws/install/setup.bash
fi

exec "$@"
