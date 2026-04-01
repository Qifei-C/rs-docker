"""Launch file for D455 calibration — high-res color + depth streams."""
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
                'camera_name': 'd455',
                'serial_no': '',

                # 校准用高分辨率
                'enable_depth': True,
                'depth_module.depth_profile': '1280x720x15',
                'depth_module.emitter_enabled': 1,

                'enable_color': True,
                'rgb_camera.color_profile': '1280x720x15',

                'enable_infra1': True,
                'enable_infra2': True,

                'enable_gyro': True,
                'enable_accel': True,
                'unite_imu_method': 2,  # linear interpolation for calibration

                'align_depth.enable': True,
                'pointcloud.enable': True,
                'pointcloud.ordered_pc': True,

                'publish_tf': True,
                'tf_publish_rate': 0.0,
            }],
            output='screen',
        ),
    ])
