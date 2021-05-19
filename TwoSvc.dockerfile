FROM chinalan/go-httpbin:1.0-alpine3.13

CMD /bin/go-httpbin -port 80& /bin/go-httpbin -port 88
