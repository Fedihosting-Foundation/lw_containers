FROM rust:1.71.1-bullseye as builder

WORKDIR /app
ARG LEMMY_VERSION

RUN cargo install \
    --git https://github.com/LemmyNet/lemmy.git \
    --tag "${LEMMY_VERSION}" \
    lemmy_server

FROM debian:bullseye-slim

LABEL org.opencontainers.image.description Image for the lemmy_server.

RUN apt-get update && \
    apt-get install -y libpq5 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/lemmy_server /app/lemmy_server
RUN adduser -h /app -s sh -S -u 1000 lemmy
RUN chown -R lemmy:lemmy /app
USER lemmy

CMD ["/app/lemmy_server"]
