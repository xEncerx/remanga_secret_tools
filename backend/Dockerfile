FROM dart:stable AS build

WORKDIR /app

COPY . .

RUN dart pub get
RUN dart run build_runner build --delete-conflicting-outputs

RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

FROM dart:stable AS runtime

WORKDIR /app

COPY --from=build /app/build .

RUN dart pub get

EXPOSE 8080

CMD ["dart", "bin/server.dart"]
