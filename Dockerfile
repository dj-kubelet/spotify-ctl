FROM alpine:latest
RUN apk add --no-cache bash curl jq
COPY spotify-ctl /
ENTRYPOINT ["/spotify-ctl"]
