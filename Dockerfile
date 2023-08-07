FROM ros:humble

# Build and install patched version of OpenVDB (see https://github.com/SteveMacenski/spatio_temporal_voxel_layer/issues/232).
RUN apt-get remove libopenvdb*; apt-get update && apt-get install -y libboost-system-dev libboost-iostreams-dev libtbb-dev libblosc-dev; \
    git clone --recurse --branch v8.2.0-debian https://github.com/wyca-robotics/openvdb.git /opt/openvdb && \
    mkdir /opt/openvdb/build && cd /opt/openvdb/build && \
    cmake .. && \
    make -j1 && make install && \
    cd ..; rm -rf /opt/openvdb/build

# Install ROS packages.
RUN apt-get update && apt-get install -y \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-navigation2 ros-humble-nav2-bringup \
    ros-humble-turtlebot3-description ros-humble-turtlebot3-node ros-humble-turtlebot3-msgs \
    ros-humble-turtlebot3-navigation2 ros-humble-turtlebot3-bringup \
    ros-humble-realsense2-camera \
    ros-dev-tools

# Requirements for LD08 (lidar) driver package (see https://github.com/ROBOTIS-GIT/ld08_driver/pull/9)
RUN apt-get install -y libudev-dev

# Perform ROS dependency installation for our workspace.
ADD ./src /opt/robot/src
RUN apt-get update && rosdep update && rosdep install --from-paths /opt/robot/src --ignore-src -r -y

# Build workspace.
ENV ROBOT_WS /opt/robot
RUN cd "$ROBOT_WS" && . /opt/ros/humble/setup.sh && colcon build

# Export the robot workspace.
RUN sed --in-place --expression \
      '$isource "$ROBOT_WS/install/setup.bash"' \
      /ros_entrypoint.sh

# Set runtime options.
ENV TURTLEBOT3_MODEL=burger
ENV LDS_MODEL=LDS-02
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
