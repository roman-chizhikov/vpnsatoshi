FROM --platform=linux golang:1.19-alpine AS builder

RUN apk add --update --no-cache make git

WORKDIR /root
COPY . ./vpnsatoshi

WORKDIR /root/vpnsatoshi
RUN go build -o ./build/vpnsatoshid ./cmd/VPNSatoshid/main.go

FROM --platform=linux alpine

COPY --from=builder /root/vpnsatoshi/build/vpnsatoshid /usr/local/bin/vpnsatoshid

ENTRYPOINT ["/usr/local/bin/vpnsatoshid"]