FROM dart:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart run build_runner build --delete-conflicting-outputs

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

RUN dart compile exe build/bin/server.dart -o build/bin/server

FROM debian:stable-slim

WORKDIR /app

COPY --from=build /app/build/bin/server ./server

EXPOSE 8080

CMD ["./server"]