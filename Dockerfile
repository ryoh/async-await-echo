# Package parameter
ARG APPNAME="async-await-echo"

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
RUN cargo install --target x86_64-unknown-linux-musl --path .

# Bundle Stage
FROM scratch
ARG APPNAME
COPY --from=builder /usr/local/cargo/bin/${APPNAME} ./app
USER 1000
CMD ["./app"]
