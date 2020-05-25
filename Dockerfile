FROM openjdk:8

LABEL maintainer="y-okubo"

ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
ENV PATH $PATH=$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools:$PATH

WORKDIR /opt

RUN wget --quiet --output-document=android-sdk.zip ${ANDROID_SDK_URL} \
  && unzip -o -qq android-sdk.zip -d android-sdk && rm android-sdk.zip \
  # Download Android SDK
  && yes | sdkmanager "build-tools;28.0.3" \
  && yes | sdkmanager "platform-tools" \
  && yes | sdkmanager "platforms;android-28" \
  && yes | sdkmanager "extras;android;m2repository" \
  && yes | sdkmanager "extras;google;google_play_services" \
  && yes | sdkmanager "extras;google;m2repository" \
  && yes | sdkmanager "ndk;21.1.6352462" \
  && yes | sdkmanager --licenses \
  # Install Fastlane
  && apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated build-essential git ruby2.5-dev \
  && gem install fastlane -v "2.144.0" --no-document \
  && gem install bundler --no-document \
  # Clean up
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && apt-get autoremove -y && apt-get clean