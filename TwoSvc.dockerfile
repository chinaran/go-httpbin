FROM chinalan/go-httpbin:1.2-alpine3.13

CMD /bin/go-httpbin -port 80 -response-delay 10ms -log-prefix "80  "& /bin/go-httpbin -port 88 -response-delay 10ms -log-prefix "88  "
