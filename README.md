# flutter-ide-docker
Flutter ide in docker

based on [cdr/code-server](https://github.com/cdr/code-server) with dart and flutter extension.

Flutter cli work out of the box. You can connect your android devices with adb or run the build on Web Server.
You can also use this emulator [docker-android](https://github.com/budtmo/docker-android) 

## Run with docker
```docker run --privileged -e DISPLAY=:0 -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/coder/.Xauthority -v /dev:/dev -it --net=host flutter-ide ```

## Run with docker compose

```docker-compose up```

