FROM ros:humble-ros-base-jammy

RUN apt update -y && apt install -y software-properties-common && \
    add-apt-repository universe

RUN sudo apt update && sudo apt install curl -y && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt install ros-humble-desktop -y && \
	apt install ros-humble-ros-base && \
	apt install -y ros-dev-tools

RUN apt -y install ros-humble-hls-lfcd-lds-driver

RUN apt -y install python3-argcomplete python3-colcon-common-extensions libboost-system-dev build-essential && \
    apt install ros-humble-turtlebot3-msgs && \
    apt install ros-humble-dynamixel-sdk && \
    apt install libudev-dev

