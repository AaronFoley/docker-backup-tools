FROM alpine:3.12.1

RUN apk add --no-cache mariadb-client postgresql-client python3 rdiff-backup bash shadow

# Setup local scripts
COPY scripts/* /usr/local/bin

# set us up to run as non-root user
RUN groupadd -g 1005 appuser && \
    useradd -r -u 1005 -g appuser appuser
USER appuser
