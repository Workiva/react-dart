FROM google/dart:2.13

WORKDIR /build
COPY pubspec.yaml .
COPY /lib ./lib/

RUN dart pub get

RUN cd lib && tar -czvf ../cdn_assets.tar.gz *.js
ARG BUILD_ARTIFACTS_CDN=/build/cdn_assets.tar.gz

FROM scratch
