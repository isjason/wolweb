# docker build -t wolweb .
FROM golang:1.21-alpine AS builder

#LABEL org.label-schema.vcs-url="https://github.com/vsc55/wolweb" \ 注释掉了标签
#      org.label-schema.url="https://github.com/vsc55/wolweb/blob/main/README.md"

RUN mkdir /wolzz
WORKDIR /wolzz

# Install Dependecies
RUN apk update && apk upgrade && \
    apk add --no-cache git && \
    git clone https://github.com/isjason/wolzz .

# Build Source Files
RUN go build -o wolzz . 

# Create 2nd Stage final image
FROM alpine
WORKDIR /wolzz
COPY --from=builder /wolzz/index.html .
COPY --from=builder /wolzz/wolzz .
COPY --from=builder /wolzz/devices.json .
COPY --from=builder /wolzz/config.json .
COPY --from=builder /wolzz/users.json .
COPY --from=builder /wolzz/static ./static

ARG WOLWEBPORT=8089

CMD ["/wolzz/wolzz"]

EXPOSE ${WOLWEBPORT}
