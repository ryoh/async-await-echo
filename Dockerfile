# Package parameter
ARG APPNAME="async-await-echo"
ARG DEFAULT_PORT="3000"

# Build Stage
FROM rust:1.64.0 AS builder
ARG APPNAME
WORKDIR /usr/src/
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new ${APPNAME}
WORKDIR /usr/src/${APPNAME}
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path . \
    && mv /usr/local/cargo/bin/${APPNAME} /usr/local/cargo/bin/app

# Bundle Stage
FROM scratch
ARG DEFAULT_PORT
ENV PORT=${DEFAULT_PORT}
COPY --from=builder /usr/local/cargo/bin/app ./app
USER 1000
CMD ["./app"]
