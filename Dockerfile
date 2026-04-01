FROM ros:humble-perception-jammy

ENV DEBIAN_FRONTEND=noninteractive

# ── 基础工具 ──
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    git \
    vim \
    usbutils \
    v4l-utils \
    python3-pip \
    python3-colcon-common-extensions \
    ros-humble-diagnostic-updater \
    ros-humble-rosbag2 \
    ros-humble-rosbag2-storage-mcap \
    && rm -rf /var/lib/apt/lists/*

# ── 从源码编译 librealsense2（兼容 ARM64 / Apple Silicon） ──
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libusb-1.0-0-dev \
    libudev-dev \
    pkg-config \
    libgtk-3-dev \
    cmake \
    build-essential \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    git clone --depth 1 --branch v2.56.3 https://github.com/IntelRealSense/librealsense.git && \
    cd librealsense && \
    mkdir build && cd build && \
    cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DBUILD_EXAMPLES=false \
      -DBUILD_GRAPHICAL_EXAMPLES=false \
      -DBUILD_WITH_OPENMP=true \
      -DFORCE_RSUSB_BACKEND=true \
      -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    rm -rf /tmp/librealsense

# ── RealSense ROS2 wrapper ──
RUN mkdir -p /ros2_ws/src && \
    cd /ros2_ws/src && \
    git clone --depth 1 --branch r/4.56.3 https://github.com/IntelRealSense/realsense-ros.git && \
    cd /ros2_ws && \
    . /opt/ros/humble/setup.sh && \
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    rm -rf /ros2_ws/log /ros2_ws/build/realsense2_camera/CMakeFiles

# ── entrypoint ──
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /ros2_ws

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
