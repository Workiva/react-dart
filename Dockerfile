FROM google/dart:2.13
COPY pubspec.yaml .
RUN dart pub get
FROM scratch
