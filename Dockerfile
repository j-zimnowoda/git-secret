FROM alpine:3.7

ARG GITSECRET_VERSION='0.3.2-r0'
# update base64 
RUN apk add --update coreutils
RUN apk add git gawk
RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/testing git-secret=${GITSECRET_VERSION}

RUN mkdir /app
COPY entrypoint.sh /app/entrypoint.sh 

ENTRYPOINT ["/app/entrypoint.sh"]
