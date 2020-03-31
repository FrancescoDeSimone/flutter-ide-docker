FROM codercom/code-server

USER root

RUN apt-get update -y && apt-get install -y gcc make build-essential wget curl unzip apt-utils xz-utils libkrb5-dev gradle libpulse0 android-tools-adb android-tools-fastboot && apt remove --purge openjdk-*-jdk && apt-get install -y openjdk-8-jdk chromium-browser
RUN usermod -aG plugdev coder && cd /lib/udev//rules.d/ && curl -O https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
USER coder 

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV CHROME_EXECUTABLE=chromium-browser
ENV ANDROID_HOME="/home/coder/.android"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_SDK_ARCHIVE="${ANDROID_HOME}/archive"
ENV ANDROID_STUDIO_PATH="/home/coder/"

RUN cd "${ANDROID_STUDIO_PATH}" && wget -qO android_studio.zip https://dl.google.com/dl/android/studio/ide-zips/3.3.0.20/android-studio-ide-182.5199772-linux.zip && unzip android_studio.zip && rm -f android_studio.zip && mkdir -p "${ANDROID_HOME}" && touch $ANDROID_HOME/repositories.cfg && wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}" && unzip -q -d "${ANDROID_HOME}" "${ANDROID_SDK_ARCHIVE}" && echo y | "${ANDROID_HOME}/tools/bin/sdkmanager" "platform-tools" "platforms;android-28" "build-tools;28.0.3" && rm "${ANDROID_SDK_ARCHIVE}"

# Flutter
ENV FLUTTER_HOME="/home/coder/flutter"
RUN git clone https://github.com/flutter/flutter $FLUTTER_HOME && $FLUTTER_HOME/bin/flutter channel master && $FLUTTER_HOME/bin/flutter upgrade && $FLUTTER_HOME/bin/flutter precache && $FLUTTER_HOME/bin/flutter config --enable-web --no-analytics && yes "y" | $FLUTTER_HOME/bin/flutter doctor --android-licenses -v
ENV PUB_CACHE=/home/coder/.pub_cache
ENV PATH="$PATH:/home/coder/flutter/bin"

# Env
RUN echo 'export PATH=${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PUB_CACHE}/bin:${FLUTTER_HOME}/.pub-cache/bin:$PATH' >>~/.bashrc
RUN code-server --install-extension Dart-Code.flutter && \
	code-server --install-extension Dart-Code.dart-code && \ 
	code-server --install-extension eamodio.gitlens && \
	code-server --install-extension vscodevim.vim

RUN sudo rm -rf /var/lib/apt/lists/*
