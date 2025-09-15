FROM arm64v8/ros:rolling

RUN apt update && apt install -y \
    ros-rolling-turtlesim \
    ros-rolling-rviz2 \
    libogre-1.12-dev \
    ros-rolling-demo-nodes-cpp \
    ros-rolling-rqt \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
