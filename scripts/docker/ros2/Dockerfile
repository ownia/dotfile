FROM arm64v8/ros:rolling

RUN apt-get update && apt-get install -y \
    ros-rolling-turtlesim \
    ros-rolling-rviz2 \
    libogre-1.12-dev \
    ros-rolling-demo-nodes-cpp \
    ros-rolling-rqt \
    ros-rolling-dummy-robot-bringup \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
