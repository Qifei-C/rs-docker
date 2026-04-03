"""Launch file for D455 in Stereo-IMU mode (no RGB, no depth)."""
from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    return LaunchDescription([
        Node(
            package='realsense2_camera',
            executable='realsense2_camera_node',
            name='d455_camera',
            namespace='camera',
            parameters=[{
                # ── 设备 ──
                'camera_name': 'd455_camera',
                'serial_no': '',

                # ── 关闭 RGB 和深度 ──
                'enable_color': False,
                'enable_depth': False,

                # ── 红外双目流 ──
                'enable_infra1': True,
                'enable_infra2': True,
                'depth_module.infra_profile': '640x480x30',
                'depth_module.emitter_enabled': 0,

                # ── 同步 ──
                'enable_sync': True,

                # ── IMU ──
                'enable_accel': True,
                'enable_gyro': True,
                'accel_fps': 200,
                'gyro_fps': 400,
                'unite_imu_method': 1,

                # ── TF ──
                'publish_tf': True,
                'tf_publish_rate': 0.0,

                # ── 点云/对齐 关闭 ──
                'pointcloud.enable': False,
                'align_depth.enable': False,

                # ── 诊断 ──
                'diagnostics_period': 1.0,
            }],
            output='screen',
        ),
    ])
