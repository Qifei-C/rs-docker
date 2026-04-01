"""Launch file for D455 recording with all streams enabled."""
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
                'camera_name': 'd455',
                'serial_no': '',  # 留空自动检测，多相机时填序列号

                # ── 深度流 ──
                'enable_depth': True,
                'depth_module.depth_profile': '848x480x30',
                'depth_module.emitter_enabled': 1,

                # ── 彩色流 ──
                'enable_color': True,
                'rgb_camera.color_profile': '848x480x30',

                # ── 红外流 ──
                'enable_infra1': True,
                'enable_infra2': True,

                # ── IMU ──
                'enable_gyro': True,
                'enable_accel': True,
                'unite_imu_method': 1,  # 0=none, 1=copy, 2=linear_interpolation

                # ── 对齐 ──
                'align_depth.enable': True,

                # ── 点云 ──
                'pointcloud.enable': False,  # 录制时关闭节省带宽，回放时开

                # ── TF ──
                'publish_tf': True,
                'tf_publish_rate': 0.0,  # 0 = 静态 TF

                # ── 诊断 ──
                'enable_rgbd': False,
                'diagnostics_period': 1.0,
            }],
            output='screen',
        ),
    ])
