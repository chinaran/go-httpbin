# syntax = docker/dockerfile:1-experimental
FROM golang:1.16 AS builder

ENV GOPROXY https://goproxy.cn,direct

WORKDIR /go/src/github.com/mccutchen/go-httpbin

RUN apt update && apt install -y upx

# Manually implement the subset of `make deps` we need to build the image
RUN cd /tmp && go get -u github.com/kevinburke/go-bindata/...

COPY . .
RUN --mount=type=cache,id=gobuild,target=/root/.cache/go-build \
    make build buildtests
RUN upx dist/go-httpbin

FROM alpine:3.13.5

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache --update add curl tzdata

ENV TZ Asia/Shanghai

COPY --from=builder /go/src/github.com/mccutchen/go-httpbin/dist/go-httpbin* /bin/

EXPOSE 80

CMD /bin/go-httpbin -port 80 -response-delay 10ms
