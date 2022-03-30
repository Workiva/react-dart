FROM google/dart:2.13

WORKDIR /build
COPY pubspec.yaml .

RUN dart pub get

COPY /lib ./lib/
RUN cd lib && tar -czvf ../cdn_assets.tar.gz react.js react_dom.js
ARG BUILD_ARTIFACTS_CDN=/build/cdn_assets.tar.gz

FROM scratch
