FROM drydock-prod.workiva.net/workiva/dart2_base_image:2 as dart2

RUN dart --version

WORKDIR /build
COPY pubspec.yaml .

RUN dart pub get

COPY /lib ./lib/
RUN cd lib && tar -czvf ../cdn_assets.tar.gz *.js *.map
ARG BUILD_ARTIFACTS_CDN=/build/cdn_assets.tar.gz

FROM scratch
