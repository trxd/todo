FROM golang:1-alpine AS builder

WORKDIR ${GOPATH}/src/github.com/prologic/todo

RUN apk --no-cache -U add build-base git; \
    git clone https://github.com/prologic/todo.git .; \
    go build -o todo -trimpath --ldflags "-s -w -buildid=" .; \
    cp todo /go/bin/; \
    cp -r static /tmp/static; \
    cp -r templates /tmp/templates

FROM alpine

WORKDIR /data
WORKDIR /app

COPY --from=builder /go/bin/todo /app/todo
COPY --from=builder /tmp/templates/ /app/templates
COPY --from=builder /tmp/static/ /app/static

EXPOSE 8000

CMD ["/app/todo", "-dbpath", "/data"]
