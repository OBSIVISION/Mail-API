# Use an official Dart runtime as a parent image
FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
COPY ./app/ ./
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server


FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

EXPOSE 8069
ENV PORT 8080
CMD ["/app/bin/server"]