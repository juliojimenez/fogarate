FROM --platform=linux/amd64 debian:stable-slim as builder
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates curl sqlite3 \
    && apt-get clean
WORKDIR /api
COPY api .
RUN curl --retry 5 -Ls https://download.racket-lang.org/releases/8.10/installers/racket-minimal-8.10-x86_64-linux-cs.sh > racket-install.sh
RUN echo "yes\n1\n" | sh racket-install.sh --create-dir --unix-style --dest /usr/ \
    && rm racket-install.sh
ENV SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_DIR="/etc/ssl/certs"
RUN raco setup
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"
RUN raco pkg install --auto compiler-lib
RUN raco exe api.rkt

FROM --platform=linux/amd64 debian:stable-slim
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates curl sqlite3 \
    && apt-get clean
WORKDIR /root/
COPY --from=builder /api/api /usr/local/bin/
CMD ["api"]
