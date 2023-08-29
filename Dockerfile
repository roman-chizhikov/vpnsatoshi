FROM --platform=linux golang:1.19-alpine AS builder

RUN apk add --update --no-cache make git

WORKDIR /root
COPY . ./vpnsatoshi

WORKDIR /root/vpnsatoshi
RUN go build -o ./build/vpnsatoshid ./cmd/VPNSatoshid/main.go

FROM --platform=linux alpine

RUN apk add --update --no-cache curl jq

COPY --from=builder /root/vpnsatoshi/build/vpnsatoshid /usr/local/bin/vpnsatoshid
COPY ./configAndRun.sh /usr/local/bin/configAndRun.sh
COPY ./genesis /usr/local/genesis

ENTRYPOINT ["/usr/local/bin/configAndRun.sh"]