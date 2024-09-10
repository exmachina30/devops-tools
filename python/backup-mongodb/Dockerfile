FROM alpine:3.14

WORKDIR /app/

RUN apk add mongodb-tools
RUN apk add tree
RUN apk add postgresql-client

RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        awscli \
    && rm -rf /var/cache/apk/*

COPY ./awesome_backup.sh /app

RUN chmod +x ./awesome_backup.sh

CMD ["/bin/sh"]