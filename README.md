# rs-docker

Intel RealSense D455 Docker setup with ROS2 Humble on Ubuntu 22.04. Designed for Mac (Apple Silicon) where native Intel SDK support is poor.

## Prerequisites

- Docker Desktop (Mac/Linux/Windows)
- Intel RealSense D455 connected via USB

## Quick Start

```bash
# Build
docker compose build

# Start container
docker compose up -d

# Enter container
docker compose exec realsense bash
```

## Stereo-IMU Mode (Recording)

Optimized for visual-inertial recording: dual IR streams only, emitter off for clean grayscale, high-rate IMU.

| Parameter | Value |
|-----------|-------|
| Infra1/Infra2 | 640x480 @ 30fps |
| Depth / RGB | disabled |
| Emitter | off |
| Accelerometer | 200 Hz |
| Gyroscope | 400 Hz |
| IMU fusion | copy (method 1) |

### Launch Camera

```bash
docker compose exec realsense bash /ros2_ws/scripts/launch_stereo_imu.sh
```

Or via ROS2 launch file:

```bash
docker compose exec realsense ros2 launch /ros2_ws/launch/d455_record.launch.py
```

### Record

In a second terminal:

```bash
# Record until Ctrl+C
docker compose exec realsense bash /ros2_ws/scripts/record.sh

# Record with custom name and duration (seconds)
docker compose exec realsense bash /ros2_ws/scripts/record.sh my_bag /ros2_ws/data 60
```

Recorded topics:
- `/camera/d455_camera/infra1/image_rect_raw`
- `/camera/d455_camera/infra1/camera_info`
- `/camera/d455_camera/infra2/image_rect_raw`
- `/camera/d455_camera/infra2/camera_info`
- `/camera/d455_camera/imu`
- `/tf_static`

Bags are saved in mcap format under `./data/` (mounted from host).

### Playback

```bash
docker compose exec realsense bash /ros2_ws/scripts/playback.sh /ros2_ws/data/<bag_name> [--loop]
```

## Calibration Mode

High-resolution streams for depth quality calibration.

| Parameter | Value |
|-----------|-------|
| Color / Depth | 1280x720 @ 15fps |
| Emitter | on |
| Point cloud | enabled |
| IMU fusion | linear interpolation (method 2) |

```bash
# Launch calibration streams
docker compose exec realsense ros2 launch /ros2_ws/launch/d455_calibration.launch.py

# Run calibration tool (interactive)
docker compose exec -it realsense bash /ros2_ws/scripts/calibrate.sh
```

## Project Structure

```
.
├── Dockerfile              # ROS2 Humble + librealsense2 (source build) + ROS2 wrapper
├── docker-compose.yml      # Container config with USB passthrough
├── entrypoint.sh           # Sources ROS2 + workspace setup
├── launch/
│   ├── d455_record.launch.py       # Stereo-IMU launch (Python)
│   └── d455_calibration.launch.py  # Calibration launch (Python)
├── scripts/
│   ├── launch_stereo_imu.sh  # Stereo-IMU launch (bash, via rs_launch.py)
│   ├── record.sh              # Record stereo-IMU topics to mcap
│   ├── playback.sh            # Playback rosbag
│   └── calibrate.sh           # Interactive calibration tool
└── data/                      # Recorded bags (host-mounted)
```
