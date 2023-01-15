# syntax = docker/dockerfile:1.3	
FROM golang:1.19 AS build

ENV GOPROXY https://goproxy.cn,direct

WORKDIR /go/src/github.com/chinaran/go-httpbin

RUN apt update && apt install -y upx

COPY . .

RUN --mount=type=cache,id=gobuild,target=/root/.cache/go-build \
    make build buildtests
RUN upx dist/go-httpbin

FROM alpine:3.17.1

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache --update add curl tzdata

ENV TZ Asia/Shanghai

COPY --from=builder /go/src/github.com/chinaran/go-httpbin/dist/go-httpbin* /bin/

EXPOSE 80

CMD /bin/go-httpbin -port 80 -response-delay 10ms
