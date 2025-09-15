xhost +local:root
docker-compose up -d

#docker run -it \
#    --env XDG_SESSION_TYPE=x11 \
#    --env DISPLAY=$DISPLAY \
#    --env QT_X11_NO_MITSHM=1 \
#    --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
#    --name ros2_container \
#    --network host \
#    ros2:arm64_rolling
