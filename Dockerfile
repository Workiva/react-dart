FROM google/dart:2.18

WORKDIR /build
COPY pubspec.yaml .

RUN dart pub get

COPY /lib ./lib/
RUN cd lib && tar -czvf ../cdn_assets.tar.gz *.js *.map
ARG BUILD_ARTIFACTS_CDN=/build/cdn_assets.tar.gz

FROM scratch
