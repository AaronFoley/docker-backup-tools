FROM alpine:3.12.1

RUN apk add --no-cache mariadb-client postgresql-client python3 rdiff-backup